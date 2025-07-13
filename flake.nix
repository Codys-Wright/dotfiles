{

	description = "FTS Flake";


	outputs = inputs@{ self, nixpkgs, ...}: 
		with inputs; let

		# ---- SYSTEM SETTINGS ---- #

		systemSettings = {
		system = "x86_64-linux";
		hostname = "nixos";
		profile = "work";
		timezone = "America/Chicago";
		locale = "en_US.UTF-8";
		bootMode = uefi;
		bootMountPath = "/boot";
		grubDevice = "";
		gpuType = "nvidia";

		};

		# ----- USER SETTINGS ----- #
	userSettings = rec {
		username = "cody"; #username
		name = "Cody"; #name/identifier
		email = "acodywright@gmail.com";
		dotfilesDir = "~/.dotfiles"; #absolute path of the local repo
		theme = "eris"; #selected theme from the themes directory (./themes/)
		wm = "hyprland"; #selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
		# window manager type (hyprland or x11) translator
		wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
		term = "kitty"; #default terminal command"
		font = "Intel One Mono"; # Selected font
		fontPkg = pkgs.intel-one-mono; # font package
		editor = "nvim";
		browser = "firefox"; # Default browser
		spawnBrowser = browser; # Browser spawning command
		spawnEditor = "exec " + term + " -e " + editor; # Editor spawning command
	};




		lib = nixpkgs.lib;
		nixpkgsWithOverlays = system: (import nixpkgs rec{

			system = systemSettings.system;

			config = {
				allowUnfree = true;
				permittedInsecurePackages = [];
			};

			overlays = [
				nur.overlays.default

				(_final: prev: {
					unstable = import nixpkgs-unstable {
						inherit (prev) system;
						inherit config;
					};
				})
			];
		});
		pkgs = nixpkgsWithOverlays systemSettings.system;

	in {
		homeConfigurations = {
			user = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			modules = [
			./profiles/${systemSettings.profile}/home.nix
			];
			extraSpecialArgs = {
			inherit pkgs;
			inherit systemSettings;
			inherit userSettings;
			inherit inputs;
			};
			};
		};
		nixosConfigurations = {
			system = lib.nixosSystem {
				system = systemSettings.system;
				pkgs = nixpkgsWithOverlays system;
				modules = [
			./profiles/${systemSettings.profile}/configuration.nix
			({ pkgs, ... }: {
				environment.systemPackages = [ inputs.nh.packages.${systemSettings.system}.default ];
			})
				];
				specialArgs = {
					inherit inputs;
					inherit systemSettings;
					inherit userSettings;
					themesDir = "${self}/themes";
				};


			};
		};

	};

	inputs = {

		nixpkgs.url = "nixpkgs/nixos-unstable";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		hyprland.url = "github:hyprwm/Hyprland";
		nur.url = "github:nix-community/NUR";
		nh.url = "github:nix-community/nh";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		stylix.url = "github:danth/stylix";
		musnix.url = "github:musnix/musnix";
		zen-browser.url = "github:0xc000022070/zen-browser-flake";

	};

}
