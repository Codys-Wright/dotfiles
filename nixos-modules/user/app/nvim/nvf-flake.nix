{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nvf,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    configModule = {
      # Add any custom options (and do feel free to upstream them!)
      # options = { ... };

      config.vim = {
        theme.enable = true;
        # and more options as you see fit...

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp-enable = true;
      };
    };

    customNeovim = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [configModule];
    };
  in {
    # This will make the package available as a flake output under 'packages'
    packages.${system}.my-neovim = customNeovim.neovim;

    # Example Home-Manager configuration using the configured Neovim package
    homeConfigurations = {
      "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
        # ...
        modules = [
          # This will make Neovim available to users using the Home-Manager
          # configuration. To make the package available to all users, prefer
          # environment.systemPackages in your NixOS configuration.
          {home.packages = [customNeovim.neovim];}
        ];
        # ...
      };
    };
  };
}
