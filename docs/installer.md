# Installer

## Setup block device

```bash { "name": "partition" }
export DEVICE="/dev/vda"
export SWAP_SIZE="4GB"

sudo parted $DEVICE -- mklabel gpt
sudo parted $DEVICE -- mkpart root ext4 512MB "-$SWAP_SIZE"
sudo parted $DEVICE -- mkpart swap linux-swap "-$SWAP_SIZE" 100%
sudo parted $DEVICE -- mkpart ESP fat32 1MB 512MB
sudo parted $DEVICE -- set 3 esp on
```

```bash { "name": "format" }
export DEVICE="/dev/vda"

sudo mkfs.ext4 -L nixos "${DEVICE}1"
sudo mkswap -L swap "${DEVICE}2"
sudo mkfs.fat -F 32 -n boot "${DEVICE}3"
```

## Install

```bash { "name": "install" }
export DEVICE="/dev/vda"
export FLAKE="./flake.nix#alice"

sudo mount /dev/disk/by-label/nixos /mnt

sudo mkdir -p /mnt/boot
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

sudo swapon "${DEVICE}2"

sudo nixos-install --flake $FLAKE
```
