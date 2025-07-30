# Language modules for coding/development
# This module imports all available programming language configurations
{ ... }:

{
  imports = [
    # Programming Languages
    ./android/android.nix # Android development tools
    ./cc/cc.nix # C/C++ development environment
    ./godot/godot.nix # Godot game engine
    ./haskell/haskell.nix # Haskell functional programming
    ./python/python.nix # Python development environment
    ./python/python-packages.nix # Additional Python packages
    ./rust/rust.nix # Rust development environment
  ];
}
