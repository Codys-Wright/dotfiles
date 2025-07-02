{ config, pkgs, ... }:

{
  imports = [
    ./app/nvim/nvim.nix
    ./app/git/git.nix
    ./app/terminal/alacritty.nix
    ./app/terminal/kitty.nix
    ./app/virtualization/virtualization.nix
    ./lang/android/android.nix
    ./lang/cc/cc.nix
    ./lang/godot/godot.nix
    ./lang/haskell/haskell.nix
    ./lang/python/python.nix
    ./lang/rust/rust.nix
    ./shell/cli-collection.nix
    ./shell/sh.nix
    ./pkgs/pokemon-colorscripts.nix
    ./pkgs/ranger.nix
    ./pkgs/rogauracore.nix
  ];

  # Additional user-level coding configurations can go here
  # For example, coding-specific user settings, keybindings, etc.
} 