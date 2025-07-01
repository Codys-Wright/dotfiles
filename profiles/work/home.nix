{ config, pkgs, systemSettings, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../user/shell/sh.nix
    ../../user/shell/cli-collection.nix
    ../../user/app/nvim/nvim.nix
    ../../user/app/git/git.nix
    ../../user/app/browser/firefox.nix
    ../../user/app/ranger/ranger.nix
    ../../user/lang/cc/cc.nix
    ../../user/lang/python/python.nix
    ../../user/lang/rust/rust.nix
    ../../user/style/stylix.nix
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "25.05";

  # Basic home packages (user-specific packages)
  home.packages = with pkgs; [
    # You can add user-specific packages here
    # These will be installed in the user's profile
  ];

  # Basic home file configuration
  home.file = {
    # You can add custom files here
  };

  # Basic environment variables
  home.sessionVariables = {
    # You can add environment variables here
  };
}
