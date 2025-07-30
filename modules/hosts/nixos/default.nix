# Add your reusable NixOS modules to this directory, on their own file (https://wiki.nixos.org/wiki/NixOS_modules).
# These are modules you would share with others, not your personal configurations.

{ lib, ... }:
let
  # Exclude specialized module directories that use unified module system or need manual importing
  excludedDirs = [ "wm" "display-managers" "bootloaders" ];

  # Get all files and directories in current path
  allPaths = lib.custom.scanPaths ./.;

  # Filter out excluded directories
  filteredPaths = builtins.filter (path:
    let
      pathName = baseNameOf (toString path);
    in
    !(builtins.elem pathName excludedDirs)
  ) allPaths;
in
{
  imports = filteredPaths;
}
