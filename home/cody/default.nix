# Cody's Portable User Profile
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ../../modules/common/user-spec.nix
  ];

  # Export the userSpec for use by other modules
  config = {
    # Cody's portable user specification
    userSpec = {
      username = "cody";
      userFullName = "Cody Wright";
      handle = "Codys-Wright";

      email = {
        personal = "cody@example.com"; # Replace with actual personal email
        gitHub = inputs.nix-secrets.email.gitHub;
        work = inputs.nix-secrets.email.work;
        # Infrastructure emails (notifier, backup, msmtp-host, etc.)
        notifier = inputs.nix-secrets.email.notifier;
        backup = inputs.nix-secrets.email.backup;
        msmtp-host = inputs.nix-secrets.email.msmtp-host;
      };

      domain = "example.com"; # Replace with actual domain

      # User preferences (portable across hosts)
      shell = "zsh";
      useYubikey = false;
      voiceCoding = false;
      useNeovimTerminal = false;

      # SSH public keys (automatically loaded from keys directory)
      sshPublicKeys =
        let
          keysDir = ./keys;
          keyFiles = lib.filesystem.listFilesRecursive keysDir;
          # Filter for .pub files and read their contents
          publicKeyFiles = builtins.filter (path: lib.hasSuffix ".pub" (toString path)) keyFiles;
        in
        map (keyFile: lib.removeSuffix "\n" (builtins.readFile keyFile)) publicKeyFiles;
    };

    # Make userSpec available to other modules
    _module.args.userSpec = config.userSpec;
  };
}
