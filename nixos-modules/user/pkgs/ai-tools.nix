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

      # Google Gemini CLI - simple wrapper with npm install
      (pkgs.writeShellApplication {
        name = "gemini";
        runtimeInputs = [pkgs.nodejs];
        text = ''
          # Set up a persistent npm cache location
          export NPM_CONFIG_CACHE="$HOME/.cache/npm-gemini"
          export NPM_CONFIG_PREFIX="$HOME/.local/share/gemini-cli"

          # Create directories if they don't exist
          mkdir -p "$NPM_CONFIG_CACHE" "$NPM_CONFIG_PREFIX"

          # Check if gemini is already installed
          if [ ! -f "$NPM_CONFIG_PREFIX/bin/gemini" ]; then
            echo "Installing @google/gemini-cli..."
            npm install -g @google/gemini-cli --cache="$NPM_CONFIG_CACHE" --prefix="$NPM_CONFIG_PREFIX"
          fi

          # Run the installed gemini
          exec "$NPM_CONFIG_PREFIX/bin/gemini" "$@"
        '';
        meta = with lib; {
          description = "Command-line AI workflow tool powered by Google Gemini";
          homepage = "https://github.com/google-gemini/gemini-cli";
          license = licenses.asl20;
          maintainers = [];
          platforms = platforms.all;
        };
      })
    ];

    # Set up environment variables if API key is provided
    home.sessionVariables = lib.mkIf (config.my.packages.aiTools.geminiApiKey != null) {
      GEMINI_API_KEY = config.my.packages.aiTools.geminiApiKey;
    };
  };
}
