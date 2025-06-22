# NixOS Module Structure Guide

This document outlines the standard patterns and structure for creating custom NixOS modules in this configuration.

## Module Architecture

All custom modules follow the LibrePhoenix pattern with three main sections:

### 1. Standard Module Structure

```nix
{ config, lib, pkgs, ... }:

{
  imports = [
    # Other modules to import (if needed)
  ];

  options = {
    # Custom option definitions using lib.mkOption
  };

  config = {
    # Actual configuration using the defined options
  };
}
```

## Option Definition Patterns

### Basic Option Types

```nix
options = {
  my.module.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable this module";
  };

  my.module.package = lib.mkOption {
    type = lib.types.package;
    default = pkgs.somePackage;
    description = "Package to use";
  };

  my.module.configPath = lib.mkOption {
    type = lib.types.str;
    default = "~/.config/app";
    description = "Configuration directory path";
  };

  my.module.extraOptions = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Additional configuration options";
  };
};
```

### Using Special Args (userSettings/systemSettings)

This configuration follows the [LibrePhoenix special args pattern](https://librephoenix.com/2024-01-28-program-a-modular-control-center-for-your-config-using-special-args-in-nixos-flakes.html) for centralized configuration management.

Options can pull defaults from structured `userSettings` attribute sets:

```nix
# Module parameters - include userSettings from special args
{ config, lib, pkgs, userSettings, systemSettings, ... }:

options = {
  my.git.userEmail = lib.mkOption {
    type = lib.types.str;
    default = userSettings.email or "user@example.com";
    description = "Git user email address";
  };

  my.git.enableOAuth = lib.mkOption {
    type = lib.types.bool;
    default = userSettings.git.enableOAuth or false;
    description = "Enable OAuth authentication";
  };

  my.terminal.defaultApp = lib.mkOption {
    type = lib.types.str;
    default = userSettings.terminal.defaultTerminal or "ghostty";
    description = "Default terminal application";
  };
};
```

### UserSettings Structure

The `userSettings` attribute set contains **only essential variables** following the LibrePhoenix pattern:

```nix
userSettings = rec {
  # User identity
  username = "user";
  name = "User Name";
  email = "user@example.com";
  
  # App selections (what apps to use, not how to configure them)
  shell = "fish";
  term = "ghostty";
  editor = "nvim";
  browser = "firefox";
  
  # UI preferences
  theme = "kanagawa";
  font = "Intel One Mono";
};
```

### Profile-Specific Configuration

App-specific configurations are handled at the **profile level**, not in userSettings:

```nix
# In profiles/wsl/home.nix
{
  # Git configuration for WSL development environment
  my.git = {
    enable = true;
    enableOAuth = true;  # Enable for private repos
    enableDelta = true;  # Better diff viewing
  };
  
  # Enable terminal git interface
  my.gitui.enable = true;
}
```

## Configuration Patterns

### Conditional Configuration

Use `if-then-else` for conditional logic:

```nix
config = {
  programs.myApp = {
    enable = config.my.module.enable;
    
    # Simple conditional
    package = if config.my.module.useUnstable
      then pkgs.unstable.myApp
      else pkgs.myApp;
    
    # Conditional configuration merging
    extraConfig = {
      basic = "setting";
    } // (
      if config.my.module.enableAdvanced
      then {
        advanced = "setting";
        features = [ "extra" ];
      }
      else {}
    );
  };
};
```

### File Deployment

Use `xdg.configFile` for configuration files:

```nix
config = {
  xdg.configFile."myapp/config.conf" = {
    source = ./config.conf;
  };

  xdg.configFile."myapp/scripts/helper.sh" = {
    source = ./scripts/helper.sh;
    executable = true;
  };
};
```

## Directory Structure

```
nixos-modules/
├── README.md                    # This guide
├── system/                     # System-level modules
│   ├── app/                    # System applications
│   └── wm/                     # Window managers
└── user/                       # User-level modules
    ├── app/                    # User applications
    │   ├── git/               # Git-related tools
    │   │   ├── git.nix        # Git configuration
    │   │   └── gitui.nix      # GitUI configuration
    │   ├── nvim/              # Neovim configuration
    │   └── terminal/          # Terminal applications
    │       ├── tmux/          # Tmux configuration
    │       └── ghostty/       # Ghostty terminal
    ├── hardware/               # Hardware-specific configs
    ├── lang/                   # Language-specific configs
    └── shell/                  # Shell configurations
```

## Example Module: git.nix

```nix
{ config, lib, pkgs, userSettings, secrets, ... }:

{
  imports = [
    # No additional imports needed
  ];

  options = {
    my.git.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable custom git configuration";
    };

    my.git.userEmail = lib.mkOption {
      type = lib.types.str;
      default = userSettings.email or "user@example.com";
      description = "Git user email address";
    };

    my.git.enableOAuth = lib.mkOption {
      type = lib.types.bool;
      default = userSettings.enableGitOAuth or false;
      description = "Enable OAuth authentication for GitHub and GitLab";
    };
  };

  config = {
    programs.git = {
      enable = config.my.git.enable;
      package = pkgs.unstable.git;
      userEmail = config.my.git.userEmail;
      
      extraConfig = {
        push.default = "current";
      } // (
        if config.my.git.enableOAuth
        then {
          url = {
            "https://oauth2:${secrets.github_token}@github.com" = {
              insteadOf = "https://github.com";
            };
          };
        }
        else {}
      );
    };
  };
}
```

## Usage in Configuration

### In home.nix or configuration.nix

```nix
{
  imports = [
    ./nixos-modules/user/app/git/git.nix
    ./nixos-modules/user/app/git/gitui.nix
  ];

  # Enable modules with custom options
  my.git.enable = true;
  my.git.enableOAuth = false;  # Override default
  my.gitui.enable = true;
}
```

## Best Practices

### 1. Naming Convention
- Use `my.moduleName.*` for custom options
- Keep module names descriptive and consistent
- Group related options under the same namespace

### 2. Special Args Usage
- Include `userSettings` and `systemSettings` in module parameters when needed
- Use essential userSettings variables (username, name, email, app selections)
- Keep userSettings minimal - app-specific configuration goes in profiles
- Use `rec` attribute sets in flake.nix for self-referencing values

### 3. Default Values
- Always provide sensible defaults independent of userSettings structure
- Use essential userSettings for identity: `userSettings.name`, `userSettings.email`
- Use `or` operator for graceful fallbacks: `userSettings.email or "user@example.com"`
- App-specific settings should have sensible defaults and be configured at profile level

### 4. Type Safety
- Always specify `type` in `lib.mkOption`
- Use appropriate types: `bool`, `str`, `int`, `package`, `listOf`, etc.
- Provide clear descriptions

### 5. Conditional Logic
- Use `if-then-else` for conditional configuration
- Use `//` operator to merge attribute sets
- Keep conditions readable and well-commented

### 6. Module Organization
- One module per tool/application
- Group related modules in directories
- Keep configuration files alongside modules
- Follow the "control center" pattern for centralized configuration

## Common Option Types

```nix
# Boolean options
type = lib.types.bool;

# String options
type = lib.types.str;

# Integer options
type = lib.types.int;

# Package options
type = lib.types.package;

# List of strings
type = lib.types.listOf lib.types.str;

# Attribute set with any values
type = lib.types.attrsOf lib.types.unspecified;

# Nullable options
type = lib.types.nullOr lib.types.str;

# Enum options
type = lib.types.enum [ "option1" "option2" "option3" ];
```

## Testing Modules

```bash
# Check flake syntax
nix flake check

# Test module parsing
nix-instantiate --parse ./nixos-modules/user/app/mymodule.nix

# Build configuration
sudo nixos-rebuild dry-build --flake ~/configuration
```

---

This structure ensures modularity, reusability, and clear configuration management across the entire NixOS configuration.