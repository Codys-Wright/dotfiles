{
  config,
  pkgs,
  nvf-config,
  ...
}: {
  # Use nvf (Neovim Nix Framework) configuration
  home.packages = [
    nvf-config.packages.${pkgs.system}.default
  ] ++ (with pkgs; [
    # Additional tools that nvf might need
    ripgrep # Useful for telescope and general searching
  ]);
}
