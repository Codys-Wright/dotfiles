{pkgs, ...}: {
  config.vim = {
    # Theme integration (will be configured by stylix)
    theme = {
      enable = false; # Disable for now, will be enabled by stylix
    };

    # Core editor settings
    viAlias = false;
    vimAlias = true;
    lineNumberMode = "relNumber";
    searchCase = "smart";

    # Clipboard integration
    clipboard = {
      registers = "unnamedplus";
    };

    # Core functionality
    treesitter.enable = true;

    # Git integration
    git.enable = true;

    # Snacks.nvim for quality of life improvements
    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        # Basic snacks configuration
        quickfile = {enabled = true;};
        bigfile = {enabled = true;};
        notifier = {enabled = true;};
        statuscolumn = {enabled = true;};
        words = {enabled = true;};
      };
    };

    # Mini.nvim essential plugins
    mini = {
      # Core mini plugins
      ai.enable = true; # Better text objects
      comment.enable = true; # Better commenting
      pairs.enable = true; # Auto pairs
      surround.enable = true; # Surround text objects

      # UI enhancements
      indentscope.enable = true; # Indent scope visualization
      cursorword.enable = true; # Highlight word under cursor

      # File and buffer management
      bufremove.enable = true; # Better buffer deletion

      # Git integration
      diff.enable = true; # Better diff visualization
      git.enable = true; # Git integration

      # Notifications
      notify.enable = true; # Better notifications
    };

    # Language support - enable basic languages
    languages = {
      nix.enable = true;
      rust.enable = true;
      python.enable = true;
      ts.enable = true; # TypeScript
      markdown.enable = true;
    };
  };
}
