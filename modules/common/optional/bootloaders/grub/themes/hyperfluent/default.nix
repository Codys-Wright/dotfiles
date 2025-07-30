# HyperFluent GRUB Theme Package
# Fetches and packages the HyperFluent theme from GitHub
# Usage: Set theme = "hyperfluent" in hostSpec.bootloader.primary.theme
{
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "hyperfluent-grub-theme";
  version = "1.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "Coopydood";
    repo = "HyperFluent-GRUB-Theme";
    rev = "v1.0.1";
    hash = "sha256-zryQsvue+YKGV681Uy6GqnDMxGUAEfmSJEKCoIuu2z8=";
  };

  installPhase = ''
    # Create output directory
    mkdir -p $out

    # Copy the nixos theme files to output
    cp -r $src/nixos/* $out/

    # Ensure theme.txt exists and is properly formatted
    if [ ! -f $out/theme.txt ]; then
      echo "Error: theme.txt not found in HyperFluent theme"
      exit 1
    fi

    # Set proper permissions
    chmod -R 644 $out/*
    find $out -type d -exec chmod 755 {} \;
  '';

  meta = with pkgs.lib; {
    description = "HyperFluent GRUB2 theme - A modern, sleek bootloader theme";
    homepage = "https://github.com/Coopydood/HyperFluent-GRUB-Theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
