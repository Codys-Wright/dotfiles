{
  description = "Fast Track Studio nvf (Neovim) Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    nixpkgs,
    nvf,
    self,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    neovimConfig = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [./nvf-module.nix];
    };
  in {
    packages.${system} = {
      default = neovimConfig.neovim;
    };

    # Allow running with `nix run` for testing
    apps.${system}.default = {
      type = "app";
      program = "${neovimConfig.neovim}/bin/nvim";
    };
  };
}
