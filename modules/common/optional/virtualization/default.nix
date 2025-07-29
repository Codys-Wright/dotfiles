{
  lib,
  pkgs,
  ...
}:

lib.custom.mkUnifiedModule {
  #
  # ========== System Configuration ==========
  #
  systemConfig = {
    # Enable virtualization features
    virtualisation = {
      # Enable libvirt for QEMU/KVM virtualization
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };

      # Enable spice USB redirection
      spiceUSBRedirection.enable = true;

      # Enable Docker containerization
      docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
      };

      # Enable Podman as Docker alternative
      podman = {
        enable = true;
        dockerCompat = false;  # Disable since we're running actual Docker
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    # System packages for virtualization
    environment.systemPackages = with pkgs; [
      # VM management
      virt-manager # GUI for managing VMs
      virt-viewer # VM console viewer
      spice-gtk # SPICE client

      # QEMU tools
      qemu_kvm # QEMU with KVM support
      qemu-utils # QEMU utilities

      # Container tools
      docker # Container runtime
      docker-compose # Multi-container applications
      podman # Alternative container runtime
      podman-compose # Docker Compose for Podman
      buildah # Container build tool
      skopeo # Container image operations

      # Network tools for virtualization
      bridge-utils # Network bridge utilities

      # Other virtualization tools
      quickemu # Simple VM creation
      distrobox # Run other Linux distributions
    ];

    # Network configuration for VMs
    networking.firewall.checkReversePath = false;

    # Add users to virtualization groups (will be handled by user config)
    users.groups.libvirtd = { };
    users.groups.docker = { };
  };

  #
  # ========== User Configuration ==========
  #
  userConfig = {
    # User packages for virtualization
    home.packages = with pkgs; [
      # GUI applications
      gnome-boxes # Simple VM manager

      # Development containers
      lazydocker # Docker TUI
      dive # Docker image analyzer

      # Remote access
      remmina # Remote desktop client
      freerdp # RDP implementation

      # Virtualization utilities
      vagrant # Development environment manager
    ];

    # Development directories for virtualization
    home.file = {
      "VMs/.keep".text = "";
      "Containers/.keep".text = "";
      "Docker/.keep".text = "";
      "Vagrant/.keep".text = "";
    };

    # Shell aliases for common virtualization tasks
    programs.bash.shellAliases = {
      # Docker shortcuts
      d = "docker";
      dc = "docker-compose";
      dp = "docker ps";
      di = "docker images";

      # Podman shortcuts
      p = "podman";
      pc = "podman-compose";
      pp = "podman ps";
      pi = "podman images";

      # VM shortcuts
      vms = "virsh list --all";
      vmstart = "virsh start";
      vmstop = "virsh shutdown";
    };
  };
}
