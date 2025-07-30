# Specifications For Individual User Profiles
{
  lib,
  ...
}:
{
  options.userSpec = lib.mkOption {
    type = lib.types.submodule {
      options = {
        # User identification
        username = lib.mkOption {
          type = lib.types.str;
          description = "The username of the user";
        };

        userFullName = lib.mkOption {
          type = lib.types.str;
          description = "The full name of the user";
        };

        handle = lib.mkOption {
          type = lib.types.str;
          description = "The handle of the user (eg: github user)";
        };

        # User contact information
        email = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "The email addresses of the user";
        };

        domain = lib.mkOption {
          type = lib.types.str;
          description = "The domain of the user";
        };

        # User environment preferences
        shell = lib.mkOption {
          type = lib.types.str;
          default = "zsh";
          description = "The default shell for the user";
        };

        home = lib.mkOption {
          type = lib.types.str;
          description = "The home directory of the user";
          # Default will be set by the multi-user system based on username
        };

        # User-specific feature flags
        useYubikey = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this user uses a yubikey";
        };

        voiceCoding = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this user uses voice coding";
        };

        useNeovimTerminal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this user uses neovim for terminals";
        };

        # User permissions and roles (per-host configurable)
        isAdmin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this user has admin privileges on this host";
        };

        extraGroups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Additional groups for this user on this host";
        };

        # SSH keys
        sshPublicKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "SSH public keys for this user";
        };
      };
    };
  };
}
