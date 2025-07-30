# Minegrub GRUB Theme Package (Minecraft Main Menu Style)
# Fetches and packages the Minegrub theme from GitHub
# Usage: Set theme = "minegrub" in hostSpec.bootloader.primary.theme
{
  pkgs,
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "minegrub-grub-theme";
  version = "3.1.0";
  
  src = pkgs.fetchFromGitHub {
    owner = "Lxtharia";
    repo = "minegrub-theme";
    rev = "v3.1.0";
    hash = "sha256-+7b0jXVVAyIAtYKeZZONZv2qzfESjwITSng1TVjyAfQ=";
  };
  
  installPhase = ''
    # Create output directory
    mkdir -p $out
    
    # Copy the minegrub theme files to output
    cp -r $src/minegrub/* $out/
    
    # Ensure theme.txt exists and is properly formatted
    if [ ! -f $out/theme.txt ]; then
      echo "Error: theme.txt not found in Minegrub theme"
      exit 1
    fi
  '';
  
  meta = with pkgs.lib; {
    description = "Minegrub GRUB2 theme - A Minecraft-styled bootloader theme (main menu)";
    homepage = "https://github.com/Lxtharia/minegrub-theme";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
} 