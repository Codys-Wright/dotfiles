# Multi-User Management System
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  hostSpec = config.hostSpec;

  # Get all enabled users from hostSpec
  enabledUsers = lib.filterAttrs (name: userConfig: userConfig.enable) hostSpec.users;

  # Get primary user configuration
  primaryUser = hostSpec.primaryUser;
  primaryUserConfig = enabledUsers.${primaryUser};

  # Helper function to load a user's profile
  loadUserProfile =
    username:
    let
      userProfilePath = lib.custom.relativeToRoot "home/${username}/default.nix";
      userProfile = import userProfilePath {
        inherit
          pkgs
          inputs
          lib
          config
          ;
      };
    in
    userProfile.config.userSpec;

  # Helper function to merge user profile with host-specific settings
  mergeUserConfig =
    username: hostUserConfig:
    let
      userProfile = loadUserProfile username;
      # Set default home directory if not defined
      defaultHome = if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}";
      homeDirectory = userProfile.home or defaultHome;
    in
    userProfile
    // {
      # Override with host-specific settings
      isAdmin = hostUserConfig.isAdmin or false;
      extraGroups = hostUserConfig.extraGroups or [ ];
      shell = hostUserConfig.shell or userProfile.shell;
      # Ensure home directory is set
      home = homeDirectory;
    };
in
{
  # Expose primary user's userSpec through config.userSpec
  userSpec = mergeUserConfig primaryUser primaryUserConfig;

  # Create system users for all enabled users + configure root
  users.users =
    (lib.mapAttrs (
      username: hostUserConfig:
      let
        userConfig = mergeUserConfig username hostUserConfig;
        adminGroups = lib.optionals userConfig.isAdmin [
          "wheel"
          "sudo"
        ];
        allGroups = adminGroups ++ userConfig.extraGroups;
      in
      {
        name = username;
        home = userConfig.home;
        shell = pkgs.${userConfig.shell};
        isNormalUser = true;
        extraGroups = allGroups;

        # SSH keys from user profile
        openssh.authorizedKeys.keys = userConfig.sshPublicKeys;

        # Password management from sops-nix
        hashedPasswordFile = lib.mkIf (config ? sops) (
          lib.mkDefault config.sops.secrets."passwords/${username}".path
        );
      }
    ) enabledUsers)
    // {
      # Configure root user with primary user's SSH keys for remote deployment
      root =
        let
          primaryUserMerged = mergeUserConfig primaryUser primaryUserConfig;
        in
        {
          openssh.authorizedKeys.keys = primaryUserMerged.sshPublicKeys;
          hashedPasswordFile = lib.mkIf (config ? sops) (
            lib.mkDefault config.sops.secrets."passwords/${primaryUser}".path
          );
          hashedPassword = lib.mkDefault config.users.users.${primaryUser}.hashedPassword;
        };
    };

  # Create SSH directories for all users
  systemd.tmpfiles.rules = lib.flatten (
    lib.mapAttrsToList (
      username: hostUserConfig:
      let
        userConfig = mergeUserConfig username hostUserConfig;
        userGroup = config.users.users.${username}.group;
      in
      [
        "d ${userConfig.home}/.ssh 0750 ${username} ${userGroup} -"
        "d ${userConfig.home}/.ssh/sockets 0750 ${username} ${userGroup} -"
      ]
    ) enabledUsers
  );

  # Enable shells used by any user
  programs.zsh.enable = lib.mkIf (lib.any (userConfig: userConfig.shell == "zsh") (
    lib.mapAttrsToList (username: hostUserConfig: mergeUserConfig username hostUserConfig) enabledUsers
  )) true;
  programs.bash.enable = lib.mkIf (lib.any (userConfig: userConfig.shell == "bash") (
    lib.mapAttrsToList (username: hostUserConfig: mergeUserConfig username hostUserConfig) enabledUsers
  )) true;
  programs.fish.enable = lib.mkIf (lib.any (userConfig: userConfig.shell == "fish") (
    lib.mapAttrsToList (username: hostUserConfig: mergeUserConfig username hostUserConfig) enabledUsers
  )) true;

}
# Home-Manager configuration for all enabled users
// lib.optionalAttrs (inputs ? "home-manager") {
  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      inherit hostSpec;
    };

    # Create home-manager users for all enabled users
    users = lib.mapAttrs (
      username: hostUserConfig:
      let
        userConfig = mergeUserConfig username hostUserConfig;

        # Load host-specific user configuration if it exists
        hostSpecificConfigPath = lib.custom.relativeToRoot "home/${username}/${hostSpec.hostName}.nix";
        hasHostSpecificConfig = builtins.pathExists hostSpecificConfigPath;

        baseImports = [
          # Import the user's default profile
          (lib.custom.relativeToRoot "home/${username}/default.nix")
        ];

        hostSpecificImports = lib.optionals hasHostSpecificConfig [
          hostSpecificConfigPath
        ];
      in
      {
        imports = baseImports ++ hostSpecificImports;

        # Pass user configuration to home-manager
        _module.args.userSpec = userConfig;
        _module.args.hostUserConfig = hostUserConfig;
      }
    ) enabledUsers;
  };
}
