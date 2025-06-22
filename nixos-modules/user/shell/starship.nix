{ config, lib, pkgs, ... }:

{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.shell.starship.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Starship prompt configuration";
    };

    my.shell.starship.enableGitIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Git branch display in prompt";
    };

    my.shell.starship.enableCloudIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AWS/GCloud/Kubernetes display in prompt";
    };
  };

  config = lib.mkIf config.my.shell.starship.enable {
    programs.starship = {
      enable = true;
      settings = {
        # Cloud services (disabled by default for cleaner prompt)
        aws.disabled = !config.my.shell.starship.enableCloudIntegration;
        gcloud.disabled = !config.my.shell.starship.enableCloudIntegration;
        kubernetes.disabled = !config.my.shell.starship.enableCloudIntegration;
        
        # Git configuration
        git_branch.style = if config.my.shell.starship.enableGitIntegration then "242" else "hidden";
        
        # Directory settings
        directory.style = "blue";
        directory.truncate_to_repo = false;
        directory.truncation_length = 8;
        
        # Language modules (minimal by default)
        python.disabled = true;
        ruby.disabled = true;
        
        # Hostname settings
        hostname.ssh_only = false;
        hostname.style = "bold green";
      };
    };
  };
}