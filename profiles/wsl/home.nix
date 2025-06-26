{
  secrets,
  pkgs,
  userSettings,
  systemSettings,
  nix-index-database,
  ...
}: {
  imports = [
    # NixOS home-manager integrations
    nix-index-database.hmModules.nix-index

    # Package collections
    ../../nixos-modules/user/pkgs/core.nix
    ../../nixos-modules/user/pkgs/development.nix
    ../../nixos-modules/user/pkgs/nix-tools.nix
    ../../nixos-modules/user/pkgs/ai-tools.nix

    # Language support
    ../../nixos-modules/user/lang/lang.nix

    # Shell configuration
    ../../nixos-modules/user/shell/fish.nix
    ../../nixos-modules/user/shell/starship.nix
    ../../nixos-modules/user/shell/cli-integrations.nix

    # App modules
    ../../nixos-modules/user/app/terminal/tmux/tmux.nix
    ../../nixos-modules/user/app/nvim/nvim.nix
    ../../nixos-modules/user/app/git/git.nix
    ../../nixos-modules/user/app/git/gitui.nix

    # Bin modules
    ../../nixos-modules/user/bin/phoenix/phoenix.nix

    #Theming Options
    ../../user/style/stylix.nix # Styling and themes for my apps

  ];

  # WSL Profile Configuration
  # Enable package collections for WSL development environment
  my.packages = {
    core.enable = true; # Essential CLI utilities
    development.enable = true; # Development tools and LSPs
    nixTools.enable = true; # Nix formatting and linting
    aiTools.enable = true; # AI development tools
  };

  # Enable language support for WSL development
  my.languages = {
    rust.enable = true; # Rust development
    cc.enable = true; # C/C++ development
    python.enable = true; # Python development
    typescript.enable = true;
    # android.enable = false;              # Not needed for WSL
    # godot.enable = false;                # Not needed for WSL
    # haskell.enable = false;              # Not needed for WSL
  };

  # Enable shell configuration for WSL
  my.shell = {
    fish = {
      enable = true;
      enableWSLIntegration = true; # WSL clipboard and explorer integration
      enableKanagawaTheme = true; # Consistent theming
    };
    starship.enable = true; # Modern prompt
    cliIntegrations.enable = true; # FZF, zoxide, direnv, etc.
  };

  # Enable development apps for WSL
  my.git = {
    enable = true;
    enableOAuth = true; # Enable for private repo access
    enableDelta = true; # Better diff viewing
  };

  my.gitui.enable = true; # Terminal git interface
  my.phoenix.enable = true; # Phoenix configuration management

  home.stateVersion = "22.11";

  home = {
    username = userSettings.username;
    homeDirectory = "/home/${userSettings.username}";

    sessionVariables = {
      EDITOR = userSettings.editor;
      TERM = userSettings.term;
      BROWSER = userSettings.browser;
    };
  };

  # WSL-specific packages not covered by collections
  home.packages = with pkgs; [
    # JeezyVim for enhanced neovim experience
    jeezyvim

    # Additional packages specific to WSL development
    # Add packages here that don't fit into the modular collections
    # Note: Phoenix is available system-wide via nixos-modules/system/bin/phoenix
  ];

  programs = {
    home-manager.enable = true;
    nix-index-database.comma.enable = true;

    # Additional programs not covered by shell modules can be configured here
  };
}
