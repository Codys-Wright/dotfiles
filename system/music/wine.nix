{ config, lib, pkgs, ... }:

{
  # Install Wine-related packages
  environment.systemPackages = with pkgs; [
    # Wine utilities
    winetricks
    
    # Audio support for Wine
    wineasio
    
    # Additional Wine tools
    cabextract
    p7zip
    
    # GUI Wine managers
    lutris
    bottles
    
    # Wine packages - using stable Wine instead of GE
    wineWowPackages.stable
    
    # Create a script to setup WineASIO
    (pkgs.writeScriptBin "setup-wineasio" ''
      #!${pkgs.bash}/bin/bash
      
      echo "Setting up WineASIO..."
      
      # Check if Wine prefix exists
      if [ ! -d "$HOME/.wine" ]; then
        echo "Creating Wine prefix..."
        wineboot --init
      fi
      
      # Install WineASIO using winetricks
      echo "Installing WineASIO..."
      winetricks wineasio
      
      # Register WineASIO DLL
      echo "Registering WineASIO DLL..."
      wine regsvr32 wineasio.dll
      
      # Apply registry settings
      echo "Applying registry settings..."
      wine regedit /tmp/wine-audio.reg
      
      echo "WineASIO setup complete!"
      echo "You may need to restart your Wine applications for changes to take effect."
    '')
  ];

  # Enable 32-bit support for Wine
  hardware.graphics.enable32Bit = true;
  services.pulseaudio.support32Bit = true;

  # Wine environment variables
  environment.variables = {
    # Wine configuration
    WINEPREFIX = "$HOME/.wine";
    WINEARCH = "win64";
    
    # Audio configuration for Wine
    WINEDLLOVERRIDES = "mscoree,mshtml=";
    
    # WineASIO specific configuration
    WINEASIO_DRIVER = "default";
    WINEASIO_SAMPLE_RATE = "48000";
    WINEASIO_BUFFER_SIZE = "256";
    
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

    # WineASIO registry configuration
    [HKEY_CURRENT_USER\Software\Wine\WineASIO]
    "Driver"="default"
    "SampleRate"="48000"
    "BufferSize"="256"
    "Enable"="1"

    [HKEY_CURRENT_USER\Software\Wine\WineASIO\Drivers]
    "Default"="default"
  '';

  # System-wide Wine configuration
  systemd.user.services.wine-prefix = {
    description = "Initialize Wine prefix for music applications";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.wineWowPackages.stable}/bin/wineboot --init";
      RemainAfterExit = true;
    };
  };


} 