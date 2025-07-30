{
  lib,
  pkgs,
  ...
}:

lib.custom.mkUnifiedModule {
  #
  # ========== System Configuration ==========
  #
  systemConfig = {
    # Allow unfree packages for code-cursor and other proprietary editors
    nixpkgs.config.allowUnfree = true;

    # System-wide editor packages
    environment.systemPackages = with pkgs; [

    ];
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # User-level editor packages and configurations
    home.packages = with pkgs; [
      # Advanced text editors
      vim
      neovim

      # IDE and code editors
      code-cursor # Cursor - AI-first coding environment

      # Additional development tools (git provided by core config)
      gh # GitHub CLI
    ];

    # Configure default editor
    home.sessionVariables = {
      EDITOR = lib.mkDefault "nvim";
      # VISUAL is set in coding/default.nix
    };

    # Git editor configuration is handled by core git config

    # XDG file associations
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = [ "code-cursor.desktop" ];
        "application/x-shellscript" = [ "code-cursor.desktop" ];
        "text/x-python" = [ "code-cursor.desktop" ];
        "text/x-rust" = [ "code-cursor.desktop" ];
        "text/javascript" = [ "code-cursor.desktop" ];
        "text/x-typescript" = [ "code-cursor.desktop" ];
        "application/json" = [ "code-cursor.desktop" ];
        "text/markdown" = [ "code-cursor.desktop" ];
      };
    };
  };
}
