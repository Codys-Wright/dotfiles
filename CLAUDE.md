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
  - Make sure to update both home.nix and flake.nix when adding dependencies
  - Keep Windows/WSL interoperability in mind