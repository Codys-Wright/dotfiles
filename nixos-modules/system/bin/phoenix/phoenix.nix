{ config, lib, pkgs, userSettings, systemSettings, ... }:
# Phoenix - LibrePhoenix-inspired NixOS configuration management layer
# Provides convenient commands for rebuilding system/user configurations
let
  configDir = userSettings.dotfilesDir;
  
  # Individual scripts
  syncScript = pkgs.writeShellScript "phoenix-sync" ''
    #!/bin/sh
    # Synchronize system and home-manager state with config files
    CONFIG_DIR="${configDir}"
    
    echo "=== Phoenix Sync: System + User ==="
    
    # Rebuild system
    echo "Building NixOS system configuration..."
    sudo nixos-rebuild switch --flake $CONFIG_DIR
    
    # Fix root-owned sqlite errors
    sudo chown -R 1000:users ~/.cache/nix 2>/dev/null || true
    
    # Rebuild home-manager
    echo "Building Home Manager configuration..."
    home-manager switch --flake $CONFIG_DIR
    
    # Run post-sync hooks
    echo "Running post-sync hooks..."
    ${postHookScript}
  '';
  
  syncSystemScript = pkgs.writeShellScript "phoenix-sync-system" ''
    #!/bin/sh
    # Only synchronize system state (nixos-rebuild switch)
    CONFIG_DIR="${configDir}"
    
    echo "=== Phoenix Sync: System Only ==="
    echo "Building NixOS system configuration..."
    sudo nixos-rebuild switch --flake $CONFIG_DIR
  '';
  
  syncUserScript = pkgs.writeShellScript "phoenix-sync-user" ''
    #!/bin/sh
    # Only synchronize home-manager state (home-manager switch)
    CONFIG_DIR="${configDir}"
    
    echo "=== Phoenix Sync: User Only ==="
    
    # Fix root-owned sqlite errors
    sudo chown -R 1000:users ~/.cache/nix 2>/dev/null || true
    
    # Rebuild home-manager
    echo "Building Home Manager configuration..."
    home-manager switch --flake $CONFIG_DIR
    
    # Run post-sync hooks
    echo "Running post-sync hooks..."
    ${postHookScript}
  '';
  
  updateScript = pkgs.writeShellScript "phoenix-update" ''
    #!/bin/sh
    # Update all flake inputs without synchronizing
    CONFIG_DIR="${configDir}"
    
    echo "=== Phoenix Update: Flake Inputs ==="
    pushd $CONFIG_DIR > /dev/null
    echo "Updating flake inputs..."
    nix flake update
    echo "Flake update completed."
    popd > /dev/null
  '';
  
  upgradeScript = pkgs.writeShellScript "phoenix-upgrade" ''
    #!/bin/sh
    # Update flake inputs and synchronize system + user
    
    echo "=== Phoenix Upgrade: Update + Sync ==="
    
    # Update flake inputs
    ${updateScript}
    
    # Synchronize system and user
    ${syncScript}
  '';
  
  postHookScript = pkgs.writeShellScript "phoenix-refresh" ''
    #!/bin/sh
    # Call synchronization posthooks (refresh stylix and dependent daemons)
    
    echo "=== Phoenix Refresh: Post-sync Hooks ==="
    
    # tmux - reload configuration if running
    if pgrep tmux > /dev/null 2>&1; then
      echo "Reloading tmux configuration..."
      tmux source-file ~/.config/tmux/tmux.conf > /dev/null 2>&1 || true
    fi
    
    # fish - configuration will be picked up in new sessions
    if pgrep fish > /dev/null 2>&1; then
      echo "Fish shell will pick up new configuration on next session"
    fi
    
    # For WSL, most GUI operations from original script don't apply:
    # - No X11/Wayland window managers (xmonad, hyprland)
    # - No notification daemons (dunst, fnott) 
    # - No background setters (feh, hyprpaper)
    # - No GUI application reloads
    
    echo "Post-sync hooks completed"
  '';
  
  pullScript = pkgs.writeShellScript "phoenix-pull" ''
    #!/bin/sh
    # Pull changes from upstream git and attempt to merge local changes
    CONFIG_DIR="${configDir}"
    
    echo "=== Phoenix Pull: Git Sync ==="
    
    # Relax permissions temporarily so git can work
    echo "Temporarily relaxing permissions..."
    ${softenScript} $CONFIG_DIR
    
    # Stash local edits, pull changes, and re-apply local edits
    pushd $CONFIG_DIR > /dev/null
    echo "Stashing local changes..."
    git stash
    echo "Pulling upstream changes..."
    git pull
    echo "Re-applying local changes..."
    git stash apply
    popd > /dev/null
    
    # Restore proper permissions
    echo "Restoring secure permissions..."
    ${hardenScript} $CONFIG_DIR
  '';
  
  hardenScript = pkgs.writeShellScript "phoenix-harden" ''
    #!/bin/sh
    # Ensure system-level files cannot be edited by unprivileged user
    
    if [ "$#" = 1 ]; then
        CONFIG_DIR=$1
    else
        CONFIG_DIR="${configDir}"
    fi
    
    echo "=== Phoenix Harden: Securing Permissions ==="
    echo "Hardening permissions for: $CONFIG_DIR"
    
    pushd $CONFIG_DIR > /dev/null
    sudo chown 0:0 .
    sudo chown 0:0 profiles
    sudo chown 0:0 profiles/*
    sudo chown -R 0:0 nixos-modules/system
    sudo chown 0:0 flake.lock
    sudo chown 0:0 flake.nix
    sudo chown 0:0 profiles/*/configuration.nix
    sudo chown 0:0 profiles/*/wsl.nix 2>/dev/null || true
    sudo chown 1000:users README.md 2>/dev/null || true
    sudo chown 1000:users CLAUDE.md 2>/dev/null || true
    sudo chown 1000:users nixos-modules/README.md 2>/dev/null || true
    echo "Configuration hardening completed."
    popd > /dev/null
  '';
  
  softenScript = pkgs.writeShellScript "phoenix-soften" ''
    #!/bin/sh
    # Relax permissions so all dotfiles can be edited by normal user
    
    if [ "$#" = 1 ]; then
        CONFIG_DIR=$1
    else
        CONFIG_DIR="${configDir}"
    fi
    
    echo "=== Phoenix Soften: Relaxing Permissions ==="
    echo "Softening permissions for: $CONFIG_DIR"
    echo "WARNING: This allows unprivileged editing of system files!"
    
    pushd $CONFIG_DIR > /dev/null
    sudo chown -R 1000:users .
    echo "Configuration softening completed."
    popd > /dev/null
  '';
  
  # Main phoenix command dispatcher
  phoenixScript = pkgs.writeShellScript "phoenix" ''
    #!/bin/sh
    
    case "$1" in
      "sync")
        case "$2" in
          "system")
            ${syncSystemScript}
            ;;
          "user")
            ${syncUserScript}
            ;;
          "")
            ${syncScript}
            ;;
          *)
            echo "Usage: phoenix sync [system|user]"
            exit 1
            ;;
        esac
        ;;
      "update")
        if [ "$#" -gt 1 ]; then
          echo "Warning: The 'update' command has no subcommands"
        fi
        ${updateScript}
        ;;
      "upgrade")
        if [ "$#" -gt 1 ]; then
          echo "Warning: The 'upgrade' command has no subcommands"
        fi
        ${upgradeScript}
        ;;
      "refresh")
        if [ "$#" -gt 1 ]; then
          echo "Warning: The 'refresh' command has no subcommands"
        fi
        ${postHookScript}
        ;;
      "pull")
        if [ "$#" -gt 1 ]; then
          echo "Warning: The 'pull' command has no subcommands"
        fi
        ${pullScript}
        ;;
      "harden")
        if [ "$#" -gt 1 ]; then
          echo "Warning: The 'harden' command has no subcommands"
        fi
        ${hardenScript}
        ;;
      "soften")
        if [ "$#" -gt 1 ]; then
          echo "Warning: The 'soften' command has no subcommands"
        fi
        ${softenScript}
        ;;
      "gc")
        if [ "$#" -gt 2 ]; then
          echo "Warning: The 'gc' command only accepts one argument"
        fi
        
        echo "=== Phoenix GC: Garbage Collection ==="
        
        case "$2" in
          "full")
            echo "Performing full garbage collection..."
            sudo nix-collect-garbage --delete-old
            nix-collect-garbage --delete-old
            ;;
          "")
            echo "Performing garbage collection (30 days)..."
            sudo nix-collect-garbage --delete-older-than 30d
            nix-collect-garbage --delete-older-than 30d
            ;;
          *d)
            echo "Performing garbage collection ($2)..."
            sudo nix-collect-garbage --delete-older-than $2
            nix-collect-garbage --delete-older-than $2
            ;;
          *)
            echo "Invalid gc argument: $2"
            echo "Usage: phoenix gc [full|Xd]"
            echo "Examples: phoenix gc full, phoenix gc 15d"
            exit 1
            ;;
        esac
        ;;
      *)
        echo "Phoenix - NixOS Configuration Management"
        echo ""
        echo "Usage: phoenix <command> [options]"
        echo ""
        echo "Commands:"
        echo "  sync [system|user]    - Rebuild configuration (both, system only, or user only)"
        echo "  update                - Update flake inputs without rebuilding"
        echo "  upgrade               - Update flake inputs + rebuild (update + sync)"
        echo "  refresh               - Run post-sync hooks (reload applications)"
        echo "  pull                  - Git pull with local changes management"
        echo "  harden                - Secure file permissions (root ownership)"
        echo "  soften                - Allow user editing of system files"
        echo "  gc [time|full]        - Garbage collection (default: 30d)"
        echo ""
        echo "Examples:"
        echo "  phoenix sync          - Full system and user rebuild"
        echo "  phoenix sync system   - System rebuild only"
        echo "  phoenix update        - Update flake inputs only"
        echo "  phoenix upgrade       - Update inputs + full rebuild"
        echo "  phoenix gc 7d         - Remove generations older than 7 days"
        echo "  phoenix gc full       - Remove all old generations"
        ;;
    esac
  '';

in
{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.phoenix.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Phoenix configuration management layer";
    };
  };

  config = lib.mkIf config.my.phoenix.enable {
    environment.systemPackages = [
      phoenixScript
    ];
  };
}