# NixOS Dotfiles Configuration

This is a comprehensive NixOS flake-based dotfiles configuration for a work setup. The configuration uses a modular approach with profiles, themes, and separate system/user configurations.

## Structure Overview

```
.dotfiles/
├── flake.nix              # Main flake configuration
├── flake.lock             # Locked dependency versions
├── profiles/              # Configuration profiles
│   └── work/
│       ├── configuration.nix  # System configuration for work profile
│       └── home.nix           # Home Manager configuration for work profile
├── system/                # System-level configurations
│   ├── nix/              # Core Nix configurations
│   ├── gaming/           # Gaming-related system packages
│   ├── coding/           # Development tools and environments
│   └── music/            # Audio/music system configuration
├── user/                 # User-level configurations (Home Manager)
│   ├── nix/              # User Nix configurations
│   ├── coding/           # Development tools and applications
│   ├── gaming/           # Gaming applications
│   ├── music/            # Music applications
│   └── shared/           # Shared user applications
└── themes/               # Color schemes and theming
```

## Key Configuration Details

### System Settings (flake.nix:11-22)
- **Architecture**: x86_64-linux
- **Hostname**: nixos
- **Profile**: work
- **Timezone**: America/Chicago
- **Locale**: en_US.UTF-8
- **Boot Mode**: UEFI
- **GPU Type**: nvidia

### User Settings (flake.nix:25-41)
- **Username**: cody
- **Email**: acodywright@gmail.com
- **Theme**: io (from themes directory)
- **Window Manager**: Hyprland (Wayland)
- **Terminal**: Kitty
- **Font**: Intel One Mono
- **Editor**: Neovim
- **Browser**: Firefox

### Key Dependencies
- **nixpkgs**: 25.05 stable
- **nixpkgs-unstable**: For newer packages
- **home-manager**: User environment management
- **hyprland**: Wayland compositor
- **nur**: Nix User Repository
- **stylix**: System-wide theming
- **nh**: Nix helper tool

### Features
- **Hyprland Configuration**: Full Wayland setup with NVIDIA support
- **Theming**: Stylix-based system-wide theming with Base16 color schemes
- **Development Setup**: Comprehensive coding environment with multiple languages
- **Gaming Support**: Steam, gamemode, and other gaming tools
- **Modular Design**: Easy to switch between profiles and configurations

### Current Status
- Modified files show active development on Hyprland configuration
- Work profile is the active configuration
- NVIDIA graphics properly configured for Wayland
- Home Manager integration for user-specific configurations

### Usage Commands
```bash
# Rebuild system configuration
sudo nixos-rebuild switch --flake .

# Update home manager
home-manager switch --flake .

# Update flake inputs
nix flake update
```

This configuration provides a complete, reproducible NixOS environment optimized for development work with modern tools and aesthetics.