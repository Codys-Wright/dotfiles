{
  config,
  pkgs,
  nvf,
  self,
  ...
}: let
  # Create nvf neovim configuration locally using the module path
  neovimConfig = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [
      "${self}/nixos-modules/user/app/nvim/nvf-module.nix"
    ];
  };
in {
  # Use locally built nvf configuration
  home.packages = [
    neovimConfig.neovim
  ];
}
