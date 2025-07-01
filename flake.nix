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

      # create patched nixpkgs
      nixpkgs-patched =
        (import inputs.nixpkgs { system = systemSettings.system; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
          patches = [ ];
        };

      # configure pkgs
      # use nixpkgs if running a server (homelab or worklab profile)
      # otherwise use patched nixos-unstable nixpkgs
      pkgs = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
              then
                pkgs-stable
              else
                (import nixpkgs-patched {
                  system = systemSettings.system;
                  config = {
                    allowUnfree = true;
                    allowUnfreePredicate = (_: true);
                  };
                }));

      pkgs-stable = import inputs.nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-unstable = import nixpkgs-patched {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
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
            inherit pkgs-stable;
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
    stylix.url = "github:danth/stylix";
  };
}
