# User config applicable only to darwin
{ config, ... }:
{
  users.users.${config.userSpec.username} = {
    home = "/Users/${config.userSpec.username}";
  };
}
