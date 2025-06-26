{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./android/android.nix
    ./cc/cc.nix
    ./godot/godot.nix
    ./haskell/haskell.nix
    ./python/python.nix
    ./rust/rust.nix
    ./typescript/typescript.nix
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

      typescript = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable TypeScript development tools";
        };

        nodejs.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Node.js runtime";
        };

        bun.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Bun runtime and package manager";
        };

        pnpm.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable pnpm package manager";
        };

        yarn.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Yarn package manager";
        };

        typescript.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable TypeScript compiler";
        };

        eslint.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable ESLint linting";
        };

        prettier.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Prettier formatting";
        };

        devTools.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable development tools (nodemon, ts-node, language servers)";
        };
      };
    };
  };
}
