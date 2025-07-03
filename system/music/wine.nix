{ config, lib, pkgs, ... }:

{
  # Wine configuration for music applications
  programs.wine = {
    enable = true;
    # Use Wine-GE for better compatibility with modern applications
    package = pkgs.wineWowPackages.ge;
  };

  # Install Wine-related packages
  environment.systemPackages = with pkgs; [
    # Wine utilities
    winetricks
    winecfg
    
    # Audio support for Wine
    wineasio
    
    # Additional Wine tools
    cabextract
    p7zip
    
    # GUI Wine managers
    lutris
    bottles
  ];

  # Enable 32-bit support for Wine
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Wine environment variables
  environment.variables = {
    # Wine configuration
    WINEPREFIX = "$HOME/.wine";
    WINEARCH = "win64";
    
    # Audio configuration for Wine
    WINEDLLOVERRIDES = "mscoree,mshtml=";
    
    # Performance optimizations
    WINEDEBUG = "-all";
  };

  # Wine registry tweaks for audio applications
  environment.etc."wine/audio.reg".text = ''
    Windows Registry Editor Version 5.00

    [HKEY_CURRENT_USER\Software\Wine\Drivers]
    "Audio"="alsa"

    [HKEY_CURRENT_USER\Software\Wine\Audio]
    "HardwareAcceleration"="1"
    "SampleRate"="48000"
    "Channels"="2"
  '';

  # System-wide Wine configuration
  systemd.user.services.wine-prefix = {
    description = "Initialize Wine prefix for music applications";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.wineWowPackages.ge}/bin/wineboot --init";
      RemainAfterExit = true;
    };
  };
} 