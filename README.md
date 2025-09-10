# Configuration

## Setup nixos

```bash
# Enable shell with git
nix-shell -p git
# Clone github config repo
git clone https://github.com/cashewnuts/nixos-config.git ~/nix-config
# Rebuild with repo
sudo nixos-rebuild boot --flake ~/nix-config
# install home-manager (standalone)
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager \
  && nix-channel --update \
  && nix-shell '<home-manager>' -A install
home-manager switch --flake ~/nix-config

# Setup fcitx for mozc
fcitx-configtool
# Generate walker config
walker -C
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
