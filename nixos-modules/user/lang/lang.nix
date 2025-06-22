{ config, lib, pkgs, ... }:

{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.languages = {
      android.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Android development tools";
      };

      cc.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable C/C++ development tools";
      };

      godot.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Godot game development tools";
      };

      haskell.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Haskell development tools";
      };

      python = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Python development tools";
        };

        includePackages = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Include additional Python packages (imath, pystring)";
        };
      };

      rust.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Rust development tools";
      };
    };
  };

  config = {
    home.packages = with pkgs; 
      # Android development
      (lib.optionals config.my.languages.android.enable [
        android-tools
        android-udev-rules
      ]) ++
      
      # C/C++ development
      (lib.optionals config.my.languages.cc.enable [
        gcc
        gnumake
        cmake
        autoconf
        automake
        libtool
      ]) ++
      
      # Godot game development
      (lib.optionals config.my.languages.godot.enable [
        godot_4
      ]) ++
      
      # Haskell development
      (lib.optionals config.my.languages.haskell.enable [
        haskellPackages.haskell-language-server
        haskellPackages.stack
      ]) ++
      
      # Python development
      (lib.optionals config.my.languages.python.enable ([
        python3Full
      ] ++ lib.optionals config.my.languages.python.includePackages [
        imath
        pystring
      ])) ++
      
      # Rust development
      (lib.optionals config.my.languages.rust.enable [
        rustup
      ]);
  };
}