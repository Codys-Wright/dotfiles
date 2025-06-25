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
    my.packages.aiTools.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AI and development assistance tools";
    };

    my.packages.aiTools.geminiApiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "API key for Google Gemini CLI (optional)";
    };
  };

  config = lib.mkIf config.my.packages.aiTools.enable {
    home.packages = with pkgs.unstable; [
      # AI related tools
      claude-code

      # Google Gemini CLI via npm
      (pkgs.writeShellScriptBin "gemini" ''
        exec ${pkgs.nodejs}/bin/npx @google/gemini-cli "$@"
      '')
    ];

    # Set up environment variables if API key is provided
    home.sessionVariables = lib.mkIf (config.my.packages.aiTools.geminiApiKey != null) {
      GEMINI_API_KEY = config.my.packages.aiTools.geminiApiKey;
    };
  };
}
