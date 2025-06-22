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
- **flake.nix**: Global settings with `systemSettings` and `userSettings` variables using special args pattern
- **profiles/**: Profile-specific configurations (currently: `wsl/`)
- **nixos-modules/**: Modular app configurations

### Special Args Pattern
This configuration follows the LibrePhoenix special args pattern ([reference article](https://librephoenix.com/2024-01-28-program-a-modular-control-center-for-your-config-using-special-args-in-nixos-flakes.html)) for centralized configuration management:

- **Essential Global Settings**: `systemSettings` and `userSettings` contain only essential variables (identity, app selections, system basics)
- **Profile-Specific Configuration**: App-specific settings are configured at the profile level, not globally
- **Minimal Repetition**: Use `inherit` and special args to avoid retyping common variables
- **Optional App Configuration**: Profiles can optionally enable and configure apps without requiring global settings
- **Special Args Passing**: Essential configuration passed to all modules via `specialArgs` and `extraSpecialArgs`

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
- `userSettings`: Essential user variables only:
  - `username`, `name`, `email` - User identity
  - `shell`, `term`, `editor`, `browser` - App selections
  - `theme`, `font` - UI preferences
- **App-specific settings**: Configured at profile level (e.g., OAuth settings in `profiles/wsl/home.nix`)

### App Modules
- **tmux.nix**: Handles tmux config, TPM (plugin manager), auto-installs plugins
- **nvim.nix**: Handles neovim config, LSPs, config files
- **git.nix**: Custom git module with configurable options (OAuth, delta, etc.)
- **gitui.nix**: GitUI terminal interface module
- Add new apps in `nixos-modules/user/app/` and import in profile's home.nix

### Usage Examples
```nix
# In profile home.nix
{
  imports = [
    ../../nixos-modules/user/lang/lang.nix
  ];
  
  # Enable specific languages for this profile
  my.languages = {
    rust.enable = true;        # Enables rustup
    cc.enable = true;          # Enables gcc, cmake, autotools
    python.enable = true;      # Enables python3Full, imath, pystring
    android.enable = false;    # Disabled for this profile
  };
}
```

### Package Collections (`nixos-modules/user/pkgs/`)
- **core.nix**: Essential CLI utilities (bat, fd, ripgrep, tree, etc.)
- **development.nix**: Development tools and language servers (language-agnostic)
- **rust.nix**: Rust ecosystem tools (rustup, cargo utilities) - *deprecated, use lang.nix*
- **nix-tools.nix**: Nix formatting and linting tools
- **ai-tools.nix**: AI development assistance tools

### Language Support (`nixos-modules/user/lang/`)
- **lang.nix**: Unified language support with per-language enable options
  - `my.languages.rust.enable` - Rust development (rustup)
  - `my.languages.cc.enable` - C/C++ development (gcc, cmake, autotools)
  - `my.languages.python.enable` - Python development (python3Full, packages)
  - `my.languages.haskell.enable` - Haskell development (stack, language server)
  - `my.languages.android.enable` - Android development (tools, udev rules)
  - `my.languages.godot.enable` - Godot game development

### Shell Modules (`nixos-modules/user/shell/`)
- **fish.nix**: Fish shell configuration with WSL integration
- **starship.nix**: Starship prompt configuration
- **cli-integrations.nix**: FZF, zoxide, broot, direnv integrations

### Module Development
- **See nixos-modules/README.md** for detailed guide on creating custom modules
- Follow LibrePhoenix pattern: `imports`, `options`, `config` sections
- Use `my.moduleName.*` for custom options with proper types and defaults
- Leverage conditional configuration with `if-then-else` patterns

### Dependencies
- Git is available system-wide (don't duplicate in app modules)
- Use `pkgs.unstable.{package}` for bleeding-edge packages
- Use `pkgs.{package}` for stable packages