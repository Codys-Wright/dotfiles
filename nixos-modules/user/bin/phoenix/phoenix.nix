{
  config,
  lib,
  pkgs,
  userSettings,
  systemSettings,
  ...
}:
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
in {
  imports = [
    # No additional imports needed
  ];

  options = {
    my.phoenix.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Phoenix configuration management layer";
    };

    my.phoenix.aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        phe = "phoenix edit";
        phqe = "phoenix quick-edit";
        phs = "phoenix sync";
        phsu = "phoenix sync user";
        phss = "phoenix sync system";
        phu = "phoenix update";
        phg = "phoenix upgrade";
        phr = "phoenix refresh";
        phpl = "phoenix pull";
        phh = "phoenix harden";
        phsf = "phoenix soften";
        phgc = "phoenix gc";
      };
      description = "Phoenix command aliases";
    };
  };

  config = lib.mkIf config.my.phoenix.enable {
    home.packages = [
      (pkgs.writeScriptBin "phoenix" ''
        #!/bin/sh

        case "$1" in
          "edit")
            echo "=== Phoenix Edit: Configuration Editor ==="
            pushd ${configDir} > /dev/null
            echo "Opening configuration in ${userSettings.editor}..."
            ${userSettings.editor} profiles/${systemSettings.profile}/configuration.nix
            popd > /dev/null
            exit 0
            ;;
          "quick-edit")
            echo "=== Phoenix Quick Edit: Edit + Sync Workflow ==="

            # Navigate to config directory
            pushd ${configDir} > /dev/null

            # Step 1: Open editor
            echo "Opening configuration in ${userSettings.editor}..."
            ${userSettings.editor} profiles/${systemSettings.profile}/configuration.nix

            # Step 2: Show git diff
            echo ""
            echo "=== Configuration Changes ==="
            if git diff --quiet; then
              echo "No changes detected."
            else
              git diff -U0 *.nix profiles/**/*.nix 2>/dev/null || git diff -U0 *.nix
            fi
            echo ""

            # Step 3: Rebuild system
            echo "=== Building NixOS system configuration ==="
            sudo nixos-rebuild switch --flake ${configDir} &> nixos-switch.log || (
              echo "Build failed! Error log:"
              cat nixos-switch.log | grep --color error
              popd > /dev/null
              exit 1
            )

            # Step 4: Fix permissions and rebuild home-manager
            sudo chown -R 1000:users ~/.cache/nix 2>/dev/null || true
            echo "=== Building Home Manager configuration ==="
            home-manager switch --flake ${configDir}

            # Step 5: Format code
            echo "=== Formatting configuration ==="
            alejandra . &>/dev/null || echo "Warning: Alejandra formatting skipped (not available)"

            # Step 6: Auto-commit
            if ! git diff --quiet || ! git diff --cached --quiet; then
              echo "=== Committing changes ==="
              gen=$(nixos-rebuild list-generations | grep current || echo "Generation info unavailable")
              git add -A
              git commit -m "$gen" || echo "Warning: Commit failed or no changes to commit"
            else
              echo "No changes to commit."
            fi

            # Step 7: Post-sync hooks
            echo "=== Running post-sync hooks ==="
            if pgrep tmux > /dev/null 2>&1; then
              echo "Reloading tmux configuration..."
              tmux source-file ~/.config/tmux/tmux.conf > /dev/null 2>&1 || true
            fi
            echo "Phoenix quick-edit completed successfully!"

            popd > /dev/null
            exit 0
            ;;
          "sync")
            # Parse flags and determine sync type
            NO_FORMAT=false
            NO_COMMIT=false
            NO_DIFF=false
            SYNC_TYPE="full"

            shift # Remove 'sync' from arguments
            for arg in "$@"; do
              case $arg in
                --no-format) NO_FORMAT=true ;;
                --no-commit) NO_COMMIT=true ;;
                --no-diff) NO_DIFF=true ;;
                system) SYNC_TYPE="system" ;;
                user) SYNC_TYPE="user" ;;
              esac
            done

            if [ "$SYNC_TYPE" = "system" ]; then
              echo "=== Phoenix Sync: System Only ==="
              echo "Building NixOS system configuration..."
              sudo nixos-rebuild switch --flake ${configDir}
              exit 0
            elif [ "$SYNC_TYPE" = "user" ]; then
              echo "=== Phoenix Sync: User Only ==="
              sudo chown -R 1000:users ~/.cache/nix 2>/dev/null || true
              echo "Building Home Manager configuration..."
              home-manager switch --flake ${configDir}
              echo "Running post-sync hooks..."
              if pgrep tmux > /dev/null 2>&1; then
                echo "Reloading tmux configuration..."
                tmux source-file ~/.config/tmux/tmux.conf > /dev/null 2>&1 || true
              fi
              echo "Post-sync hooks completed"
              exit 0
            else
              # Full sync workflow (no editor)
              echo "=== Phoenix Sync: Build + Format + Commit ==="

              # Navigate to config directory
              pushd ${configDir} > /dev/null

              # Step 1: Show git diff (unless --no-diff)
              if [ "$NO_DIFF" = false ]; then
                echo "=== Configuration Changes ==="
                if git diff --quiet; then
                  echo "No changes detected."
                else
                  git diff -U0 *.nix profiles/**/*.nix 2>/dev/null || git diff -U0 *.nix
                fi
                echo ""
              fi

              # Step 2: Rebuild system
              echo "=== Building NixOS system configuration ==="
              sudo nixos-rebuild switch --flake ${configDir} &> nixos-switch.log || (
                echo "Build failed! Error log:"
                cat nixos-switch.log | grep --color error
                popd > /dev/null
                exit 1
              )

              # Step 3: Fix permissions and rebuild home-manager
              sudo chown -R 1000:users ~/.cache/nix 2>/dev/null || true
              echo "=== Building Home Manager configuration ==="
              home-manager switch --flake ${configDir}

              # Step 4: Format code (unless --no-format)
              if [ "$NO_FORMAT" = false ]; then
                echo "=== Formatting configuration ==="
                alejandra . &>/dev/null || echo "Warning: Alejandra formatting skipped (not available)"
              fi

              # Step 5: Auto-commit (unless --no-commit)
              if [ "$NO_COMMIT" = false ]; then
                if ! git diff --quiet || ! git diff --cached --quiet; then
                  echo "=== Committing changes ==="
                  gen=$(nixos-rebuild list-generations | grep current || echo "Generation info unavailable")
                  git add -A
                  git commit -m "$gen" || echo "Warning: Commit failed or no changes to commit"
                else
                  echo "No changes to commit."
                fi
              fi

              # Step 6: Post-sync hooks
              echo "=== Running post-sync hooks ==="
              if pgrep tmux > /dev/null 2>&1; then
                echo "Reloading tmux configuration..."
                tmux source-file ~/.config/tmux/tmux.conf > /dev/null 2>&1 || true
              fi
              echo "Phoenix sync completed successfully!"

              popd > /dev/null
              exit 0
            fi
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
            echo "  edit                  - Open configuration file in editor"
            echo "  quick-edit            - Edit + sync workflow (edit + diff + rebuild + format + commit)"
            echo "  sync [system|user]    - Sync configuration (diff + rebuild + format + commit)"
            echo "  update                - Update flake inputs without rebuilding"
            echo "  upgrade               - Update flake inputs + rebuild (update + sync)"
            echo "  refresh               - Run post-sync hooks (reload applications)"
            echo "  pull                  - Git pull with local changes management"
            echo "  harden                - Secure file permissions (root ownership)"
            echo "  soften                - Allow user editing of system files"
            echo "  gc [time|full]        - Garbage collection (default: 30d)"
            echo ""
            echo "Sync Options:"
            echo "  --no-diff             - Skip showing git diff"
            echo "  --no-format           - Skip alejandra formatting"
            echo "  --no-commit           - Skip auto-commit"
            echo ""
            echo "Examples:"
            echo "  phoenix edit          - Just open configuration file"
            echo "  phoenix quick-edit    - Full edit + sync workflow"
            echo "  phoenix sync          - Sync existing changes"
            echo "  phoenix sync --no-commit - Sync without committing"
            echo "  phoenix sync system   - System rebuild only"
            echo "  phoenix sync user     - User rebuild only"
            echo "  phoenix update        - Update flake inputs only"
            echo "  phoenix upgrade       - Update inputs + full rebuild"
            echo "  phoenix gc 7d         - Remove generations older than 7 days"
            echo "  phoenix gc full       - Remove all old generations"
            ;;
        esac
      '')
    ];
  };
}
