{ config, lib, pkgs, userSettings, ... }:

{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.shell.fish.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Fish shell configuration";
    };

    my.shell.fish.enableWSLIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable WSL-specific integrations (clipboard, explorer)";
    };

    my.shell.fish.enableKanagawaTheme = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Kanagawa theme for Fish shell";
    };
  };

  config = lib.mkIf config.my.shell.fish.enable {
    programs.fish = {
      enable = true;
      
      interactiveShellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        ${lib.optionalString config.my.shell.fish.enableKanagawaTheme
          (pkgs.lib.strings.fileContents (pkgs.fetchFromGitHub {
            owner = "rebelot";
            repo = "kanagawa.nvim";
            rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
            sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
          } + "/extras/kanagawa.fish"))}

        set -U fish_greeting
        ${lib.optionalString config.my.shell.fish.enableWSLIntegration
          "fish_add_path --append /mnt/c/Users/Cody/scoop/apps/win32yank/0.1.1/"}
      '';
      
      functions = {
        refresh = "source $HOME/.config/fish/config.fish";
        take = ''mkdir -p -- "$1" && cd -- "$1"'';
        ttake = "cd $(mktemp -d)";
        show_path = "echo $PATH | tr ' ' '\n'";
        posix-source = ''
          for i in (cat $argv)
            set arr (echo $i |tr = \n)
            set -gx $arr[1] $arr[2]
          end
        '';
      };
      
      shellAbbrs = {
        gc = "nix-collect-garbage --delete-old";
        # Navigation shortcuts
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        # Git shortcuts
        gapa = "git add --patch";
        grpa = "git reset --patch";
        gst = "git status";
        gdh = "git diff HEAD";
        gp = "git push";
        gph = "git push -u origin HEAD";
        gco = "git checkout";
        gcob = "git checkout -b";
        gcm = "git checkout master";
        gcd = "git checkout develop";
        gsp = "git stash push -m";
        gsa = "git stash apply stash^{/";
        gsl = "git stash list";
      };
      
      shellAliases = {
        jvim = "nvim";
        lvim = "nvim";
      } // lib.optionalAttrs config.my.shell.fish.enableWSLIntegration {
        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
      };
      
      plugins = [
        {
          inherit (pkgs.fishPlugins.autopair) src;
          name = "autopair";
        }
        {
          inherit (pkgs.fishPlugins.done) src;
          name = "done";
        }
        {
          inherit (pkgs.fishPlugins.sponge) src;
          name = "sponge";
        }
      ];
    };

    # Set session variables
    home.sessionVariables = {
      SHELL = "/etc/profiles/per-user/${userSettings.username}/bin/${userSettings.shell}";
    };
  };
}