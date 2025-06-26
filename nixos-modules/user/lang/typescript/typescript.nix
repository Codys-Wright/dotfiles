{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.languages.typescript.enable {
    home.packages = with pkgs;
      # Node.js runtime
      (lib.optionals config.my.languages.typescript.nodejs.enable [
        nodejs_20
      ])
      ++
      # Bun runtime and package manager
      (lib.optionals config.my.languages.typescript.bun.enable [
        bun
      ])
      ++
      # Package managers
      (lib.optionals config.my.languages.typescript.pnpm.enable [
        nodePackages.pnpm
      ])
      ++
      (lib.optionals config.my.languages.typescript.yarn.enable [
        nodePackages.yarn
      ])
      ++
      # TypeScript compiler
      (lib.optionals config.my.languages.typescript.typescript.enable [
        nodePackages.typescript
      ])
      ++
      # Linting and formatting
      (lib.optionals config.my.languages.typescript.eslint.enable [
        nodePackages.eslint
      ])
      ++
      (lib.optionals config.my.languages.typescript.prettier.enable [
        nodePackages.prettier
      ])
      ++
      # Development tools
      (lib.optionals config.my.languages.typescript.devTools.enable [
        nodePackages.nodemon
        nodePackages.ts-node
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
      ]);
  };
}