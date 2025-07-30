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
    # Import all system-level configurations from coding modules
    imports = lib.custom.importSystemModules {
      path = lib.custom.relativeToOptionalModules "coding";
      modules = [
        # Editor applications
        "app/editors"

        # Programming languages (all imported via lang/default.nix)
        "lang"
      ];
    };

    # Global development tools at system level
    environment.systemPackages = with pkgs; [
      # Version control (git is provided by core config)
      git-lfs

      # Build tools
      gnumake
      cmake

      # Development utilities
      curl
      wget
      jq

      # Documentation tools
      man-pages
      man-pages-posix
    ];

    # Enable development-friendly services
    programs.nix-ld.enable = true; # For running unpatched binaries
    services.pcscd.enable = true; # Smart card daemon for security tokens
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # Import all user-level configurations from coding modules
    imports = lib.custom.importUserModules {
      path = lib.custom.relativeToOptionalModules "coding";
      modules = [
        # Editor applications
        "app/editors"

        # Programming languages (all imported via lang/default.nix)
        "lang"
      ];
    };

    # User-level development tools
    home.packages = with pkgs; [
      # Terminal multiplexers
      tmux
      screen

      # Network tools for development
      netcat
      nmap

      # File managers for development
      ranger

      # Development utilities
      tree
      file
      which

      # Documentation viewers
      man
      tldr
    ];

    # Development environment variables
    home.sessionVariables = {
      # Common development paths
      EDITOR = lib.mkDefault "nvim";
      VISUAL = lib.mkDefault "code-cursor";
      BROWSER = lib.mkDefault "firefox";

      # Development settings
      TERM = lib.mkDefault "xterm-256color"; # Terminal capabilities for development
      COLORTERM = lib.mkDefault "truecolor";
    };

    # Git configuration is handled by core git config and development modules

    # Shell aliases for development
    programs.bash.shellAliases = {
      # Git shortcuts
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";

      # Development shortcuts
      ll = "ls -la";
      la = "ls -A";
      ".." = "cd ..";
      "..." = "cd ../..";

      # Editor shortcuts
      v = "nvim";
      c = "code-cursor";
    };

    # Development directory structure
    home.file = {
      "Development/.keep".text = "";
      "Development/projects/.keep".text = "";
      "Development/sandbox/.keep".text = "";
      "Development/tmp/.keep".text = "";
    };
  };
}
