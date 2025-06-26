# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Documentation Update History

- Added comprehensive documentation update process notes to capture the importance of maintaining clear, up-to-date documentation for the configuration system
- Documented the need to reflect status, configuration overview, and future reference guidelines in the project documentation
- Emphasized the importance of keeping the CLAUDE.md file current with any significant changes to the configuration architecture or usage patterns

## Secrets Management with sops-nix

This configuration uses sops-nix for secure secrets management. Here's how it works:

### Architecture
- **Private key**: `~/.config/sops/age/keys.txt` (local, never committed)
- **Public key**: Referenced in `.sops.yaml` (committed)
- **Encrypted secrets**: `secrets/secrets.yaml` (encrypted, safe to commit)
- **Configuration**: `.sops.yaml` defines encryption rules

### Key Components
1. **System secrets**: `nixos-modules/system/sops.nix` - for system-level secrets
2. **User secrets**: `nixos-modules/user/sops.nix` - for home-manager secrets
3. **Secrets file**: `secrets/secrets.yaml` - encrypted YAML with all secrets
4. **Age key**: Generated locally, used for encryption/decryption

### How It Works
1. Age key pair generated locally (public key in `.sops.yaml`, private key in `~/.config/sops/age/keys.txt`)
2. Secrets encrypted with public key using sops
3. NixOS modules decrypt secrets at runtime using private key
4. Secrets available to services/applications via file paths

### Usage
- **Edit secrets**: `nix shell nixpkgs#sops -c sops secrets/secrets.yaml`
- **Generate new key**: `nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt`
- **Get public key**: `nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt`

### Security
- Only encrypted data is committed to git
- Private keys stay local and are gitignored
- Each machine has its own key pair
- Secrets are decrypted at runtime by NixOS

### Example Secret Usage
```nix
# In system configuration
sops.secrets."myservice/password" = {
  owner = "myservice";
  mode = "0400";
};

# Access in service
systemd.services.myservice.script = ''
  password=$(cat ${config.sops.secrets."myservice/password".path})
'';
```