{ inputs, config, ... }:
let
  sopsFolder = (builtins.toString inputs.nix-secrets) + "/sops";
in
{
  sops.secrets = {
    "passwords/msmtp" = {
      sopsFile = "${sopsFolder}/shared.yaml";
          owner = config.users.users.${config.userSpec.username}.name;
    inherit (config.users.users.${config.userSpec.username}) group;
    };
  };

  programs.msmtp = {
    enable = true;
    setSendmail = true; # set the system sendmail to msmtp's

    accounts = {
      "default" = {
        host = "${config.userSpec.email.msmtp-host}";
        port = 587;
        auth = true;
        tls = true;
        tls_starttls = true;
        from = "${config.userSpec.email.notifier}";
        user = "${config.userSpec.email.notifier}";
        passwordeval = "cat ${config.sops.secrets."passwords/msmtp".path}";
        logfile = "~/.msmtp.log";
      };
    };
  };
}
