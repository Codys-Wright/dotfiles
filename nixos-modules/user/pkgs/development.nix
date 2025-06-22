{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # No additional imports needed
  ];

  options = {
    my.packages.development.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable development tools package collection";
    };

    my.packages.development.includeLanguageServers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include language servers for development";
    };

    my.packages.development.includeFormatters = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include code formatters and linters";
    };
  };

  config = lib.mkIf config.my.packages.development.enable {
    home.packages = with pkgs;
      [
        # Key development tools
        gh # GitHub CLI for bootstrapping
        just # Command runner
        git-crypt # Git encryption

        # Development utilities
        mkcert # Local HTTPS certificates
        httpie # HTTP client
        tree-sitter # Parser generator
      ]
      ++ lib.optionals config.my.packages.development.includeLanguageServers [
        # Language servers
        nodePackages.vscode-langservers-extracted # html, css, json, eslint
        nodePackages.yaml-language-server
        nil # nix language server
      ]
      ++ lib.optionals config.my.packages.development.includeFormatters [
        # Formatters and linters
        nodePackages.prettier
        shellcheck
        shfmt
      ];
  };
}
