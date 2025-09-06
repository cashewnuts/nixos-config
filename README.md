# Configuration


## Setup nixos

```bash
# Enable shell with git
nix-shell -p git
# Clone github config repo
git clone https://github.com/cashewnuts/nixos-config.git ~/nix-config
# Rebuild with repo
sudo nixos-rebuild switch --flake ~/nix-config
```

## Basic commands
```bash
# Rebuild OS level config with ~/nix-config
sudo nixos-rebuild switch --flake ~/nix-config
# Update home-manager
home-manager switch --flake ~/nix-config
```

