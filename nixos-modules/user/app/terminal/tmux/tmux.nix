{
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
  };

  # Copy tmux configuration files to ~/.config/tmux/
  xdg.configFile."tmux/tmux.conf" = {
    source = ./tmux.conf;
  };

  xdg.configFile."tmux/tmux.reset.conf" = {
    source = ./tmux.reset.conf;
  };

  xdg.configFile."tmux/scripts/cal.sh" = {
    source = ./scripts/cal.sh;
    executable = true;
  };

  # Copy TPM (Tmux Plugin Manager) to user directory
  xdg.configFile."tmux/plugins/tpm" = {
    source = ./plugins/tpm;
    recursive = true;
  };

  # Set environment variable for TPM plugin path
  home.sessionVariables = {
    TMUX_PLUGIN_MANAGER_PATH = "$HOME/.config/tmux/plugins";
  };

  # Add any tmux-related packages
  home.packages = with pkgs; [
    tmux
    # git is already available from other parts of the config
  ];

  # Auto-install TPM plugins on activation
  home.activation.installTmuxPlugins = config.lib.dag.entryAfter ["writeBoundary"] ''
    # Only run if tmux config exists and plugins aren't already installed
    if [ -f "$HOME/.config/tmux/tmux.conf" ] && [ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]; then
      # Check if plugins directory is empty or missing key plugins
      if [ ! -d "$HOME/.config/tmux/plugins" ] || [ -z "$(ls -A "$HOME/.config/tmux/plugins" 2>/dev/null | grep -v tpm)" ]; then
        echo "Installing tmux plugins via TPM..."
        $DRY_RUN_CMD "$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
      fi
    fi
  '';
}
