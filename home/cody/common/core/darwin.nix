# Core home functionality that will only work on Darwin
{ config, ... }:
{
  home.sessionPath = [ "/opt/homebrew/bin" ];

  home = {
    username = config.userSpec.username;
    homeDirectory = config.userSpec.home;
  };
}
