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
```

## Basic commands

### Rebuild OS level config with ~/nix-config

```bash { "name": "update" }
sudo nixos-rebuild switch --flake ~/nix-config
```

### Remove all generation

```bash { "name": "remove-all-generations" }
sudo nix-collect-garbage -d
```

### Remove generation with period

```bash { "name": "remove-3days-generations" }
sudo nix-collect-garbage --delete-older-than 3d
```

```bash { "name": "remove-1days-generations" }
sudo nix-collect-garbage --delete-older-than 1d
```

## build iso

```bash { "name": "build_iso" }
nix build ~/nix-config#build_iso
```

## build installer

```bash { "name": "build_installer" }
nix build ~/nix-config#build_installer
```

## miscellaneous

```bash { "name": "echo" }
export MSG="helloworld"
sudo echo $MSG
```

```bash { "cwd": "..", "name": "cwd" }
pwd
```
