{ config, lib, pkgs, userSettings, secrets, ... }:

{
  imports = [
    # No additional imports needed for this module
  ];

  options = {
    my.git.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable custom git configuration";
    };

    my.git.userEmail = lib.mkOption {
      type = lib.types.str;
      default = userSettings.email or "user@example.com";
      description = "Git user email address";
    };

    my.git.userName = lib.mkOption {
      type = lib.types.str;
      default = userSettings.gitUsername or userSettings.name or "user";
      description = "Git user name";
    };

    my.git.enableOAuth = lib.mkOption {
      type = lib.types.bool;
      default = userSettings.enableGitOAuth or false;
      description = "Enable OAuth authentication for GitHub and GitLab";
    };

    my.git.enableDelta = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable delta diff viewer";
    };
  };

  config = {
    programs.git = {
      enable = config.my.git.enable;
      package = pkgs.unstable.git;
      
      userEmail = config.my.git.userEmail;
      userName = config.my.git.userName;
      
      delta = if config.my.git.enableDelta
        then {
          enable = true;
          options = {
            line-numbers = true;
            side-by-side = true;
            navigate = true;
          };
        }
        else { enable = false; };
      
      extraConfig = {
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      } // (
        if config.my.git.enableOAuth
        then {
          url = {
            "https://oauth2:${secrets.github_token}@github.com" = {
              insteadOf = "https://github.com";
            };
            "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
              insteadOf = "https://gitlab.com";
            };
          };
        }
        else {}
      );
    };
  };
}
