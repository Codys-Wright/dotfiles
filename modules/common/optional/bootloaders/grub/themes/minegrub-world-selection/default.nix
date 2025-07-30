# Minegrub World Selection GRUB Theme Package (Minecraft World Selection Style)
# Fetches and packages the Minegrub World Selection theme from GitHub
# Usage: Set theme = "minegrub-world-selection" in hostSpec.bootloader.primary.theme
{
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "minegrub-world-selection-grub-theme";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "Lxtharia";
    repo = "minegrub-world-sel-theme";
    rev = "v1.0.0";
    hash = "sha256-rsnmjQH+/luj+erDK4HjzRwpVnorV9Eh7tdA7FeIbpw=";
  };

  installPhase = ''
    # Create output directory
    mkdir -p $out

    # Copy the minegrub-world-selection theme files to output
    cp -r $src/minegrub-world-selection/* $out/

    # Ensure theme.txt exists and is properly formatted
    if [ ! -f $out/theme.txt ]; then
      echo "Error: theme.txt not found in Minegrub World Selection theme"
      exit 1
    fi
  '';

  meta = with pkgs.lib; {
    description = "Minegrub World Selection GRUB2 theme - Minecraft world selection style bootloader theme";
    homepage = "https://github.com/Lxtharia/minegrub-world-sel-theme";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}