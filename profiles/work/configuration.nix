{ pkgs, lib, systemSettings, userSettings, inputs, ... }:

{
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/app/virtualization.nix
    ( import ../../system/app/docker.nix {storageDriver = null; inherit pkgs userSettings lib;} )
    ../../system/app/steam.nix
    ../../system/app/flatpak.nix
    ../../system/wm/pipewire.nix
    ../../system/style/stylix.nix
    ../../system/bin/phoenix.nix
      (./. + "../../../system/wm"+("/"+userSettings.wm)+".nix") # My window manager
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Enable nh (Nix helper)
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    # Construct absolute path by: /home/username + (dotfilesDir with ~/ removed)
    # userSettings.dotfilesDir = "~/.dotfiles" -> substring removes "~/" -> "/.dotfiles"
    # Result: /home/cody/.dotfiles
    flake = "/home/${userSettings.username}" + (builtins.substring 2 (builtins.stringLength userSettings.dotfilesDir) userSettings.dotfilesDir);
  };

  # User account
  users.users.${userSettings.username} = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" "input" "video" "render" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Install firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features for flakes and nix-command
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    git
    coreutils
    curl
    du-dust
    yazi
    procs
    mprocs
    wget
    zip
    htop
    neofetch
    findutils
    fx
    discord
    sd
    obsidian
    code-cursor
    inputs.nh.packages.${systemSettings.system}.default
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.05";
}
