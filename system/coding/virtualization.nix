{ config, pkgs, userSettings, ... }:

{
  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    # Core virtualization
    virt-manager
    qemu
    qemu_kvm
    OVMF # UEFI firmware for VMs (macOS, Windows)
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    adwaita-icon-theme
    distrobox
    
    # OSX-KVM specific packages
    dmg2img
    python3
    python3Packages.requests
    python3Packages.tqdm
    p7zip
    libguestfs
    wget
    git
    gnumake
    tesseract
    cdrtools # Includes genisoimage
    vim
    nettools
    screen
    
    # Additional tools for macOS VMs
    libguestfs
  ];
  users.users.${userSettings.username}.extraGroups = [ "libvirtd" "kvm" "input" ];

  # Load KVM modules for Intel CPU
  boot.kernelModules = [ "kvm" "kvm-intel" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1
    options vfio_iommu_type1 allow_unsafe_interrupts=1
  '';

  # Enable IOMMU for device passthrough
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];

  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [
        "nm-bridge"
        "virbr0"
      ];
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    waydroid.enable = true;
    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;
}