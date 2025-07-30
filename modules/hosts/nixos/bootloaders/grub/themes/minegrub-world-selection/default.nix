# Minegrub World Selection GRUB Theme Package (Minecraft World Selection Style)
# Fetches and packages the Minegrub World Selection theme from GitHub
# Usage: Set theme = "minegrub-world-selection" in hostSpec.bootloader.primary.theme
{
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "minegrub-world-selection-grub-theme";
  version = "latest";

  src = pkgs.fetchFromGitHub {
    owner = "Lxtharia";
    repo = "minegrub-world-sel-theme";
    rev = "3e0f8fff8340c996991841a36d52e37d1cdb54a3";
    hash = "sha256-D9D64eCXbSv2VwDzl0y6uE6liUzKSl6DRs4VG/TnkSc=";
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
