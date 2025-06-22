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

### Configuration Variables

#### System Settings (`systemSettings`)
Essential system-level configuration:
- `system`: Architecture (x86_64-linux)
- `hostname`: System hostname
- `profile`: Profile selector ("wsl", "desktop", "server", etc.)
- `timezone`: System timezone
- `locale`: System locale

#### User Settings (`userSettings`)
Essential user identity and app selections:
- **Identity**: `username`, `name`, `email`
- **App Selections**: `shell`, `term`, `editor`, `browser`
- **UI Preferences**: `theme`, `font`
- **Profile-specific settings**: Configured at profile level

## Modular Architecture

### Package Collections (`nixos-modules/user/pkgs/`)

Reusable package groups that can be enabled per-profile:

- **`core.nix`**: Essential CLI utilities
  - `my.packages.core.enable` - Core tools (bat, fd, ripgrep, tree, curl, etc.)
  - `my.packages.core.includeUnstable` - Use bleeding-edge versions when available

- **`development.nix`**: Language-agnostic development tools
  - `my.packages.development.enable` - Dev tools (gh, just, git-crypt, mkcert, httpie)
  - `my.packages.development.includeLanguageServers` - LSPs (HTML, CSS, JSON, YAML, Nix)
  - `my.packages.development.includeFormatters` - Code formatters (prettier, shellcheck)

- **`nix-tools.nix`**: Nix ecosystem tools
  - `my.packages.nixTools.enable` - Nix tools (alejandra, statix, deadnix)

- **`ai-tools.nix`**: AI development assistance
  - `my.packages.aiTools.enable` - AI tools (claude-code)

### Language Support (`nixos-modules/user/lang/`)

**`lang.nix`**: Unified language development environments

```nix
my.languages = {
  rust.enable = true;              # Rust development (rustup)
  cc.enable = true;                # C/C++ (gcc, cmake, autotools)
  python = {
    enable = true;                 # Python development
    includePackages = true;        # Additional packages (imath, pystring)
  };
  haskell.enable = false;          # Haskell (stack, language server)
  android.enable = false;          # Android development tools
  godot.enable = false;            # Godot game development
};
```

### Shell Configuration (`nixos-modules/user/shell/`)

- **`fish.nix`**: Fish shell with extensive configuration
  - `my.shell.fish.enable` - Enable Fish shell
  - `my.shell.fish.enableWSLIntegration` - WSL clipboard/explorer integration
  - `my.shell.fish.enableKanagawaTheme` - Consistent color theming

- **`starship.nix`**: Modern cross-shell prompt
  - `my.shell.starship.enable` - Enable Starship prompt
  - `my.shell.starship.enableGitIntegration` - Git branch display
  - `my.shell.starship.enableCloudIntegration` - AWS/GCloud/K8s display

- **`cli-integrations.nix`**: Enhanced CLI tools
  - `my.shell.cliIntegrations.enable` - Enable all CLI integrations
  - Includes: FZF (fuzzy finder), zoxide (smart cd), broot (tree navigator), direnv, lsd (modern ls)

### App Modules (`nixos-modules/user/app/`)

Individual application configurations:

- **`git/git.nix`**: Git configuration
  - `my.git.enable` - Enable git configuration
  - `my.git.enableOAuth` - OAuth for private repos
  - `my.git.enableDelta` - Enhanced diff viewer
  - `my.git.enableSignedCommits` - GPG commit signing

- **`git/gitui.nix`**: Terminal git interface
  - `my.gitui.enable` - Enable gitui

- **`terminal/tmux/tmux.nix`**: Terminal multiplexer
  - TPM plugin manager with auto-installation
  - Custom configuration and key bindings

- **`nvim/nvim.nix`**: Neovim editor configuration
  - Language server integration
  - Plugin management

## Profile Examples

### WSL Development Profile
```nix
# profiles/wsl/home.nix
{
  imports = [
    # Package collections
    ../../nixos-modules/user/pkgs/core.nix
    ../../nixos-modules/user/pkgs/development.nix
    ../../nixos-modules/user/pkgs/nix-tools.nix
    ../../nixos-modules/user/pkgs/ai-tools.nix
    
    # Language support
    ../../nixos-modules/user/lang/lang.nix
    
    # Shell configuration
    ../../nixos-modules/user/shell/fish.nix
    ../../nixos-modules/user/shell/starship.nix
    ../../nixos-modules/user/shell/cli-integrations.nix
    
    # App modules
    ../../nixos-modules/user/app/git/git.nix
    ../../nixos-modules/user/app/git/gitui.nix
  ];

  # Enable package collections for development
  my.packages = {
    core.enable = true;
    development.enable = true;
    nixTools.enable = true;
    aiTools.enable = true;
  };
  
  # Enable languages for WSL development
  my.languages = {
    rust.enable = true;
    cc.enable = true;
    python.enable = true;
  };
  
  # Configure shell for WSL
  my.shell = {
    fish = {
      enable = true;
      enableWSLIntegration = true;
    };
    starship.enable = true;
    cliIntegrations.enable = true;
  };
  
  # Enable git with OAuth for private repos
  my.git = {
    enable = true;
    enableOAuth = true;
    enableDelta = true;
  };
}
```

### Server Profile (Example)
```nix
# profiles/server/home.nix - Minimal server setup
{
  imports = [
    ../../nixos-modules/user/pkgs/core.nix
    ../../nixos-modules/user/shell/fish.nix
    ../../nixos-modules/user/app/git/git.nix
  ];

  # Minimal package set for servers
  my.packages.core.enable = true;
  
  # Basic shell without WSL integrations
  my.shell.fish.enable = true;
  
  # Git without OAuth (use SSH keys)
  my.git = {
    enable = true;
    enableOAuth = false;
  };
}
```

## Adding New Profiles

To create a new profile (e.g., "desktop", "gaming", "minimal"):

1. **Create profile directory**: `profiles/desktop/`
2. **Create configuration.nix**: System-level configuration
3. **Create home.nix**: User-level configuration with module imports
4. **Update flake.nix**: Set `systemSettings.profile = "desktop"`

```nix
# profiles/desktop/home.nix - Example desktop profile
{
  imports = [
    # All package collections
    ../../nixos-modules/user/pkgs/core.nix
    ../../nixos-modules/user/pkgs/development.nix
    ../../nixos-modules/user/lang/lang.nix
    
    # Desktop-specific apps
    # Add browser, media, gaming modules here
  ];

  # Desktop-focused configuration
  my.packages = {
    core.enable = true;
    development.enable = false;  # Minimal dev tools
  };
  
  my.languages = {
    # Enable only languages you need
    python.enable = true;
  };
}
```

## Common Usage Patterns

### Quick Package Management
```nix
# Disable bleeding-edge versions for stability
my.packages.core.includeUnstable = false;

# Minimal development setup
my.packages.development = {
  enable = true;
  includeLanguageServers = false;
  includeFormatters = false;
};

# Language-specific development
my.languages = {
  rust.enable = true;           # Only Rust
  python = {
    enable = true;
    includePackages = false;    # Just python3Full
  };
};
```

### Shell Customization
```nix
# Minimal shell setup
my.shell = {
  fish.enable = true;
  starship = {
    enable = true;
    enableCloudIntegration = true;  # For DevOps work
  };
  cliIntegrations.enable = false;   # Disable for simpler setup
};

# WSL-specific optimizations
my.shell.fish = {
  enable = true;
  enableWSLIntegration = true;      # Clipboard, explorer access
  enableKanagawaTheme = true;       # Consistent theming
};
```

## Troubleshooting

### Package Collisions
**Error**: `collision between /nix/store/.../package-version1 and /nix/store/.../package-version2`

**Solution**: Check for duplicate packages in different modules
```bash
# Find which modules include the conflicting package
grep -r "packagename" nixos-modules/
```

**Common causes**:
- Same package in both stable and unstable lists
- Package included in multiple collection modules
- Language-specific packages conflicting with general dev tools

### Module Import Errors
**Error**: `path '/nix/store/.../module.nix' does not exist`

**Solutions**:
1. **Check import paths**: Ensure relative paths are correct
2. **Verify module exists**: Use `ls nixos-modules/path/to/module.nix`
3. **Git status**: Ensure files are committed to repository

### Build Failures
**Error**: Various Nix evaluation errors

**Debug steps**:
```bash
# Check syntax of specific module
nix-instantiate --parse ./nixos-modules/user/app/mymodule.nix

# Test flake evaluation
nix flake check --show-trace

# Dry build without applying
sudo nixos-rebuild dry-build --flake ~/configuration
```

### Performance Optimization
- **Large profile imports**: Split large profiles into smaller, focused modules
- **Unused packages**: Disable unnecessary package collections
- **Build times**: Use `my.packages.core.includeUnstable = false` for faster builds

### WSL-Specific Issues
- **Clipboard not working**: Ensure `win32yank` is installed on Windows
- **Explorer not opening**: Check Windows path in Fish configuration
- **Theme not applied**: Verify `enableKanagawaTheme = true` in Fish module

## Module Development
- **See nixos-modules/README.md** for detailed guide on creating custom modules
- Follow LibrePhoenix pattern: `imports`, `options`, `config` sections
- Use proper option types and defaults
- Test modules individually before integrating

## Maintenance

### Keeping Documentation Updated
Always update CLAUDE.md when:
- Adding new modules or package collections
- Changing module option names or defaults
- Adding new profiles or usage patterns
- Fixing common issues or adding troubleshooting steps

### Best Practices
- **Modular design**: Keep modules focused and reusable
- **Clear naming**: Use descriptive option names
- **Good defaults**: Provide sensible defaults for all options
- **Documentation**: Document all custom options and usage patterns
- **Testing**: Test changes with `nix flake check` before committing
- Use `my.moduleName.*` for custom options with proper types and defaults
- Leverage conditional configuration with `if-then-else` patterns

### Dependencies
- Git is available system-wide (don't duplicate in app modules)
- Use `pkgs.unstable.{package}` for bleeding-edge packages
- Use `pkgs.{package}` for stable packages