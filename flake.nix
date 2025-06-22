#comment
{
  description = "Personal NixOs Configuration";

  outputs = inputs @ {self, ...}:
    with inputs; let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux"; # system arch
      hostname = "nixos"; # hostname
      profile = "wsl"; # select a profile defined from profiles directory
      timezone = "America/Los_Angeles"; # select timezone
      locale = "en_US.UTF-8"; # select locale
    };

    # ----- USER SETTINGS ----- #
    userSettings = {
      username = "fasttrackstudio"; # username
      name = "Fast Track Studio"; # name/identifier
      shell = "fish"; # default shell
    };

    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");

    nixpkgsWithOverlays = system: (import nixpkgs rec {
      inherit system;

      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          # FIXME:: add any insecure packages you absolutely need here
        ];
      };

      overlays = [
        nur.overlays.default
        jeezyvim.overlays.default

        (_final: prev: {
          unstable = import nixpkgs-unstable {
            inherit (prev) system;
            inherit config;
          };
        })
      ];
    });

    configurationDefaults = args: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-backup";
      home-manager.extraSpecialArgs = args;
    };

    argDefaults = {
      inherit secrets inputs self nix-index-database systemSettings userSettings;
      channels = {
        inherit nixpkgs nixpkgs-unstable;
      };
    };

    mkNixosConfiguration = {
      system ? systemSettings.system,
      hostname ? systemSettings.hostname,
      username ? userSettings.username,
      args ? {},
      modules,
    }: let
      specialArgs = argDefaults // {inherit hostname username;} // args;
    in
      nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        pkgs = nixpkgsWithOverlays system;
        modules =
          [
            (configurationDefaults specialArgs)
            home-manager.nixosModules.home-manager
          ]
          ++ modules;
      };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.nixos = mkNixosConfiguration {
      modules = [
        nixos-wsl.nixosModules.wsl
        (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
      ];
    };
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    jeezyvim.url = "github:LGUG2Z/JeezyVim";
  };
}
