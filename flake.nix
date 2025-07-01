{
  description = "Cody's NixOS Configuration";

  outputs = inputs@{ self, ... }:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        profile = "work"; # start with work profile
        timezone = "America/New_York";
        locale = "en_US.UTF-8";
        bootMode = "uefi";
        bootMountPath = "/boot";
        gpuType = "amd"; # based on your hardware config
      };

      # ----- USER SETTINGS ----- #
      userSettings = {
        username = "cody";
        name = "cody";
        email = "acodywright@gmail.com";
        dotfilesDir = "~/.dotfiles";
        wm = "plasma"; # your current setup
        wmType = "x11"; # plasma with x11
        browser = "firefox";
        term = "fish";
        editor = "neovim";
      };

      # configure pkgs with overlays (stable + unstable)
      pkgs = import inputs.nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = [
          (_final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (prev) system;
              inherit (prev) config;
            };
          })
        ];
      };

      # configure lib
      lib = inputs.nixpkgs.lib;

      # Systems that can run tests:
      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor =
        forAllSystems (system: import inputs.nixpkgs { inherit system; });

    in {
      homeConfigurations = {
        user = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      # No packages or apps needed for now
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}
