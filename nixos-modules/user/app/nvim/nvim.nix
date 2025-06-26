{
  config,
  pkgs,
  nvf,
  ...
}: let
  # Create nvf neovim configuration locally using the module path
  neovimConfig = nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [
      ./nvf-config/nvf-module.nix
    ];
  };
in {
  # Use locally built nvf configuration
  home.packages = [
    neovimConfig.neovim
  ];
}
