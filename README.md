## TLDR: Install my dotfiles on a fresh NixOS system

```sh
nix-shell -p git --command "nix run --experimental-features 'nix-command flakes' github:Codys-Wright/dotfiles"
```
