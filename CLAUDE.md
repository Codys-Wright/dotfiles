# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Lint/Test Commands

- Build/rebuild NixOS: `sudo nixos-rebuild switch --flake ~/configuration`
- Update flake: `nix flake update`
- Lint Nix files: `statix check`
- Format Nix files: `alejandra .`
- Format Lua files: `stylua .`
- Garbage collect old generations: `nix-collect-garbage --delete-old`

## Code Style Guidelines

- **Nix**:
  - Format with Alejandra
  - Keep FIXME comments until addressed
  - Use explicit imports
  - Follow statix recommendations (disabled rules in statix.toml)

- **Lua** (Neovim):
  - Indent with 2 spaces
  - Max line length: 120 characters
  - Use LazyVim plugin architecture

- **General**:
  - Use descriptive naming
  - Follow existing patterns when modifying config files
  - Keep Windows/WSL interoperability in mind

## Project Structure

This NixOS configuration uses a **profile-based architecture** inspired by LibrePhoenix's nixos-config:

### Core Architecture
- **flake.nix**: Global settings with `systemSettings` and `userSettings` variables
- **profiles/**: Profile-specific configurations (currently: `wsl/`)
- **nixos-modules/**: Modular app configurations

### Profile System
- `systemSettings.profile` in flake.nix determines which profile to load
- Current profile: "wsl" loads from `profiles/wsl/`
- To add new profiles: create `profiles/{name}/configuration.nix` and `profiles/{name}/home.nix`

### File Organization
```
flake.nix                          # Global settings, profile selector
profiles/wsl/
  ├── configuration.nix            # WSL system config (imports wsl.nix)
  ├── wsl.nix                      # WSL-specific NixOS settings
  └── home.nix                     # WSL home-manager config (imports app modules)
nixos-modules/user/app/
  ├── nvim/nvim.nix               # Neovim configuration module
  └── terminal/tmux/tmux.nix      # Tmux configuration module
```

### Key Variables
- `systemSettings`: hostname, profile, timezone, locale, system
- `userSettings`: username, name, shell preferences

### App Modules
- **tmux.nix**: Handles tmux config, TPM (plugin manager), auto-installs plugins
- **nvim.nix**: Handles neovim config, LSPs, config files
- Add new apps in `nixos-modules/user/app/` and import in profile's home.nix

### Dependencies
- Git is available system-wide (don't duplicate in app modules)
- Use `pkgs.unstable.{package}` for bleeding-edge packages
- Use `pkgs.{package}` for stable packages