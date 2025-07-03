{ pkgs, userSettings, inputs, ... }:
# TODO make this work on nix-on-droid!
let
  # Helper function to create scripts with proper runtime dependencies
  createScript = name: script: pkgs.writeShellApplication {
    name = name;
    runtimeInputs = with pkgs; [ git nix inputs.nh.packages.${pkgs.system}.default ];
    text = script;
  };

  # Individual script functions
  syncScript = createScript "phoenix-sync" ''
    #!/bin/bash
    echo "🔄 Syncing system and user configurations..."
    
    # Sync system
    echo "📦 Updating system configuration..."
    nh os switch /home/${userSettings.username}/.dotfiles#nixosConfigurations.system
    
    # Sync user
    echo "🏠 Updating user configuration..."
    nh home switch /home/${userSettings.username}/.dotfiles#homeConfigurations.user.activationPackage -b backup
    
    # Run post-sync hooks to reload theme-dependent services
    echo "🎨 Running post-sync hooks..."
    
    # Hyprland-specific reloads
    if pgrep Hyprland &> /dev/null; then
      echo "🔄 Reloading Hyprland..."
      hyprctl reload &> /dev/null
    fi
    
    # Restart waybar if running
    if pgrep .waybar-wrapped &> /dev/null; then
      echo "📊 Restarting waybar..."
      killall .waybar-wrapped &> /dev/null
      waybar &> /dev/null & disown
    fi
    
    # Restart fnott if running
    if pgrep fnott &> /dev/null; then
      echo "🔔 Restarting fnott..."
      killall fnott &> /dev/null
      fnott &> /dev/null & disown
    fi
    
    # Restart hyprpaper to apply new background
    if pgrep hyprpaper &> /dev/null; then
      echo "🖼️ Restarting hyprpaper..."
      killall hyprpaper &> /dev/null
      hyprpaper &> /dev/null & disown
    fi
    
    # Restart dunst if running (for notifications)
    if pgrep .dunst-wrapped &> /dev/null; then
      echo "📢 Restarting dunst..."
      killall .dunst-wrapped &> /dev/null
      dunst &> /dev/null & disown
    fi
    
    echo "✅ Sync complete!"
  '';

  syncSystemScript = createScript "phoenix-sync-system" ''
    #!/bin/bash
    echo "📦 Updating system configuration..."
    nh os switch /home/${userSettings.username}/.dotfiles#nixosConfigurations.system
    echo "✅ System sync complete!"
  '';

  syncUserScript = createScript "phoenix-sync-user" ''
    #!/bin/bash
    echo "🏠 Updating user configuration..."
    nh home switch /home/${userSettings.username}/.dotfiles#homeConfigurations.user.activationPackage -b backup
    echo "✅ User sync complete!"
  '';

  updateScript = createScript "phoenix-update" ''
    #!/bin/bash
    echo "🔄 Updating flake inputs..."
    cd ${userSettings.dotfilesDir}
    nix flake update
    echo "✅ Flake inputs updated!"
  '';

  upgradeScript = createScript "phoenix-upgrade" ''
    #!/bin/bash
    echo "⬆️ Upgrading system..."
    cd ${userSettings.dotfilesDir}
    nix flake update
    nh os switch ${userSettings.dotfilesDir}#nixosConfigurations.system
    nh home switch ${userSettings.dotfilesDir}#homeConfigurations.user.activationPackage
    echo "✅ System upgraded!"
  '';

  gcScript = createScript "phoenix-gc" ''
    #!/bin/bash
    echo "🧹 Running garbage collection..."
    
    if [ "$1" = "full" ]; then
      echo "🗑️ Full garbage collection..."
      nh clean --keep 0
    elif [ "$1" ]; then
      echo "🗑️ Garbage collection older than $1..."
      nh clean --keep-since "$1"
    else
      echo "🗑️ Garbage collection older than 30 days..."
      nh clean --keep-since 30d
    fi
    
    echo "✅ Garbage collection complete!"
  '';

  posthookScript = createScript "phoenix-posthook" ''
    #!/bin/bash
    echo "🎨 Running post-sync hooks..."
    
    # Hyprland-specific reloads
    if pgrep Hyprland &> /dev/null; then
      echo "🔄 Reloading Hyprland..."
      hyprctl reload &> /dev/null
    fi
    
    # Restart waybar if running
    if pgrep .waybar-wrapped &> /dev/null; then
      echo "📊 Restarting waybar..."
      killall .waybar-wrapped &> /dev/null
      waybar &> /dev/null & disown
    fi
    
    # Restart fnott if running
    if pgrep fnott &> /dev/null; then
      echo "🔔 Restarting fnott..."
      killall fnott &> /dev/null
      fnott &> /dev/null & disown
    fi
    
    # Restart hyprpaper to apply new background
    if pgrep hyprpaper &> /dev/null; then
      echo "🖼️ Restarting hyprpaper..."
      killall hyprpaper &> /dev/null
      hyprpaper &> /dev/null & disown
    fi
    
    # Restart dunst if running (for notifications)
    if pgrep .dunst-wrapped &> /dev/null; then
      echo "📢 Restarting dunst..."
      killall .dunst-wrapped &> /dev/null
      dunst &> /dev/null & disown
    fi
    
    echo "✅ Post-sync hooks complete!"
  '';

  # Main phoenix script that dispatches to the appropriate sub-script
  phoenixScript = pkgs.writeShellApplication {
    name = "phoenix";
    runtimeInputs = with pkgs; [ git nix inputs.nh.packages.${pkgs.system}.default ];
    text = ''
    #!/bin/bash
    
    case "$1" in
      "sync")
        if [ "$#" = 1 ]; then
          ${syncScript}/bin/phoenix-sync
        elif [ "$2" = "user" ]; then
          ${syncUserScript}/bin/phoenix-sync-user
        elif [ "$2" = "system" ]; then
          ${syncSystemScript}/bin/phoenix-sync-system
        else
          echo "❌ Please pass 'system' or 'user' if supplying a second argument"
          exit 1
        fi
        ;;
      "update")
        ${updateScript}/bin/phoenix-update
        ;;
      "upgrade")
        ${upgradeScript}/bin/phoenix-upgrade
        ;;
      "gc")
        ${gcScript}/bin/phoenix-gc "$2"
        ;;
      "posthook")
        ${posthookScript}/bin/phoenix-posthook
        ;;
      *)
        echo "🚀 Phoenix - NixOS Configuration Manager"
        echo ""
        echo "Usage: phoenix <command> [options]"
        echo ""
        echo "Commands:"
        echo "  sync [system|user]  Sync system and/or user configuration"
        echo "  update              Update flake inputs"
        echo "  upgrade             Update and apply all changes"
        echo "  gc [time|full]      Run garbage collection"
        echo "  posthook            Run post-sync hooks to reload theme services"
        echo ""
        echo "Examples:"
        echo "  phoenix sync        # Sync both system and user"
        echo "  phoenix sync system # Sync only system"
        echo "  phoenix sync user   # Sync only user"
        echo "  phoenix gc 7d       # Remove generations older than 7 days"
        echo "  phoenix gc full     # Remove all old generations"
        ;;
    esac
  '';
  };

in
{
  environment.systemPackages = [
    phoenixScript
  ];
}
