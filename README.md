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

# Remove all generation
sudo nix-collect-garbage -d
# Remove generation with period
sudo nix-collect-garbage --delete-older-than 3d
# Expire home manager generation with days
home-manager expire-generations "-3 days"
```

