{ config, pkgs, systemSettings, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
