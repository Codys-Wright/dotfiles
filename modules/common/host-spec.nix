# Specifications For Differentiating Hosts
{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Import bootloader options from the dedicated options file
  bootloaderOptionsModule = import ./optional/bootloaders/options.nix { inherit lib; };

in
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      freeformType = with lib.types; attrsOf str;
      options = {
        # Host identification
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "The hostname of the host";
        };

        # Multi-user configuration
        users = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to enable this user on this host";
                };
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
                shell = lib.mkOption {
                  type = lib.types.str;
                  default = "zsh";
                  description = "Override default shell for this user on this host";
                };
              };
            }
          );
          default = { };
          description = "Attribute set of users to configure on this host with their host-specific settings";
        };

        # Primary user for system-level configurations
        primaryUser = lib.mkOption {
          type = lib.types.str;
          description = "The primary user for this host (used for SSH, root configurations, etc.)";
        };

        # Host-level configuration (removed user-specific fields)
        work = lib.mkOption {
          default = { };
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set of work-related information if isWork is true";
        };
        networking = lib.mkOption {
          default = { };
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set of networking information";
        };
        wifi = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate if a host has wifi";
        };
        persistFolder = lib.mkOption {
          type = lib.types.str;
          description = "The folder to persist data if impermenance is enabled";
          default = "";
        };

        # Host characteristics
        isMinimal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a minimal host";
        };
        isMobile = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a mobile host";
        };
        isProduction = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Used to indicate a production host";
        };
        isServer = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a server host";
        };
        isWork = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses work resources";
        };
        # Sometimes we can't use pkgs.stdenv.isLinux due to infinite recursion
        isDarwin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that is darwin";
        };
        useYubikey = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate if the host uses a yubikey";
        };
        voiceCoding = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses voice coding";
        };
        isAutoStyled = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that wants auto styling like stylix";
        };
        useNeovimTerminal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses neovim for terminals";
        };
        useWindowManager = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Used to indicate a host that uses a window manager";
        };
        useAtticCache = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Used to indicate a host that uses LAN atticd for caching";
        };
        hdr = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that uses HDR";
        };
        scaling = lib.mkOption {
          type = lib.types.str;
          default = "1";
          description = "Used to indicate what scaling to use. Floating point number";
        };

        # Bootloader configuration imported from bootloader options module
        bootloader = bootloaderOptionsModule.bootloaderOptions;
      };
    };
  };

  config = {
    assertions =
      let
        # We import these options to HM and NixOS, so need to not fail on HM
        isImpermanent =
          config ? "system" && config.system ? "impermanence" && config.system.impermanence.enable;
        hostSpec = config.hostSpec;
        primaryUserExists = hostSpec ? primaryUser && hostSpec.users ? ${hostSpec.primaryUser};
        primaryUserEnabled = primaryUserExists && hostSpec.users.${hostSpec.primaryUser}.enable;
      in
      [
        {
          assertion =
            !config.hostSpec.isWork || (config.hostSpec.isWork && !builtins.isNull config.hostSpec.work);
          message = "isWork is true but no work attribute set is provided";
        }
        {
          assertion = !isImpermanent || (isImpermanent && !("${config.hostSpec.persistFolder}" == ""));
          message = "config.system.impermanence.enable is true but no persistFolder path is provided";
        }
        {
          assertion = primaryUserExists;
          message = "primaryUser '${hostSpec.primaryUser or "undefined"}' must be defined in hostSpec.users";
        }
        {
          assertion = primaryUserEnabled;
          message = "primaryUser '${hostSpec.primaryUser or "undefined"}' must be enabled in hostSpec.users";
        }
      ];
  };
}
