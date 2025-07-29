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

        # Programming languages
        "lang/android"
        "lang/cc"
        "lang/godot"
        "lang/haskell"
        "lang/python"
        "lang/rust"
      ];
    };

    # Global development tools at system level
    environment.systemPackages = with pkgs; [
      # Version control
      git
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

        # Programming languages
        "lang/android"
        "lang/cc"
        "lang/godot"
        "lang/haskell"
        "lang/python"
        "lang/rust"
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
      TERM = "xterm-256color";
      COLORTERM = "truecolor";
    };

    # Git global configuration (basic setup, specific per-language configs in their modules)
    programs.git = {
      enable = true;
      delta.enable = true; # Better diff viewer

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        core.autocrlf = false;

        # Performance settings
        core.preloadindex = true;
        core.fscache = true;
        gc.auto = 256;
      };
    };

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
