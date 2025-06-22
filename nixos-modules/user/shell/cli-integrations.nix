{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # No additional imports needed
  ];

  options = {
    my.shell.cliIntegrations.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable CLI integrations (fzf, zoxide, broot, direnv)";
    };

    my.shell.cliIntegrations.enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Fish shell integrations for CLI tools";
    };

    my.shell.cliIntegrations.enableLsd = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable lsd (modern ls replacement) with aliases";
    };
  };

  config = lib.mkIf config.my.shell.cliIntegrations.enable {
    programs = {
      # Fuzzy finder
      fzf = {
        enable = true;
        enableFishIntegration = config.my.shell.cliIntegrations.enableFishIntegration;
      };

      # Smart directory navigation
      zoxide = {
        enable = true;
        enableFishIntegration = config.my.shell.cliIntegrations.enableFishIntegration;
        options = ["--cmd cd"];
      };

      # Tree-style file manager
      broot = {
        enable = true;
        enableFishIntegration = config.my.shell.cliIntegrations.enableFishIntegration;
      };

      # Environment management
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # Modern ls replacement
      lsd = lib.mkIf config.my.shell.cliIntegrations.enableLsd {
        enable = true;
        enableAliases = true;
      };
    };

    # Enable nix-index integration
    programs.nix-index = {
      enable = true;
      enableFishIntegration = config.my.shell.cliIntegrations.enableFishIntegration;
    };
  };
}
