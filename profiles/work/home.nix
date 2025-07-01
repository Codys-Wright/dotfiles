{ config, pkgs, pkgs-stable, pkgs-kdenlive, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  programs.home-manager.enable = true;

  imports = [
              (./. + "../../user/wm"+("/"+userSettings.wm+"/"+userSettings.wm)+".nix") # My window manager selected from flake
              ../../user/shell/sh.nix # My zsh and bash config
              ../../user/shell/cli-collection.nix # Useful CLI apps
              #../../user/app/doom-emacs/doom.nix # My doom emacs config
              ../../user/app/nvim/nvim.nix # My neovim config
              #../../user/app/emacsng # Me experimenting with emacsng and a vanilla config
              ../../user/app/ranger/ranger.nix # My ranger file manager config
              ../../user/app/git/git.nix # My git config
              #../../user/app/keepass/keepass.nix # My password manager
              (./. + "../../user/app/browser"+("/"+userSettings.browser)+".nix") # My default browser selected from flake
              ../../user/app/virtualization/virtualization.nix # Virtual machines
              #../../user/app/flatpak/flatpak.nix # Flatpaks
              ../../user/style/stylix.nix # Styling and themes for my apps
              ../../user/lang/cc/cc.nix # C and C++ tools
              ../../user/lang/godot/godot.nix # Game development
              ../../user/app/terminal/alacritty.nix # Alacritty terminal
              ../../user/app/terminal/kitty.nix # Kitty terminal
              #../../user/pkgs/blockbench.nix # Blockbench ## marked as insecure
              #../../user/hardware/bluetooth.nix # Bluetooth
            ];

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core utilities
    git
    zsh
  ];

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    SPAWNEDITOR = userSettings.spawnEditor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };

  news.display = "silent";
}
