# Installer

## Setup block device

```bash { "name": "partition", "interactive": true }
export DEVICE="/dev/vda"
export SWAP_SIZE="4GB"

sudo parted $DEVICE -- mklabel gpt
sudo parted $DEVICE -- mkpart root ext4 512MB "-$SWAP_SIZE"
sudo parted $DEVICE -- mkpart swap linux-swap "-$SWAP_SIZE" 100%
sudo parted $DEVICE -- mkpart ESP fat32 1MB 512MB
sudo parted $DEVICE -- set 3 esp on
```

```bash { "name": "format", "interactive": true  }
export DEVICE="/dev/vda"

sudo mkfs.ext4 -L nixos "${DEVICE}1"
sudo mkswap -L swap "${DEVICE}2"
sudo mkfs.fat -F 32 -n boot "${DEVICE}3"
```

## Disk setup

### Normal setup

```bash { "name": "mount", "interactive": true  }
export DEVICE="/dev/vda"

sudo mount /dev/disk/by-label/nixos /mnt

sudo mkdir -p /mnt/boot
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

sudo swapon "${DEVICE}2"
```

```bash { "name": "mount", "interactive": true  }
export DEVICE="/dev/vda"

sudo mount /dev/disk/by-label/nixos /mnt

sudo mkdir -p /mnt/boot
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

sudo swapon "${DEVICE}2"
```

### LUKS setup

```bash { "name": "format-luks", "tag": ["luks"], "interactive": true  }
export DEVICE="/dev/vda"

sudo cryptsetup luksFormat "${DEVICE}1"
sudo systemd-cryptenroll --fido2-device=auto --fido2-with-client-pin=false --wipe-slot=1 "${DEVICE}1"
sudo systemd-cryptsetup attach root "${DEVICE}1" none fido2-device=auto
sudo mkfs.ext4 /dev/mapper/root

sudo mkswap -L swap "${DEVICE}2"
sudo mkfs.fat -F 32 -n boot "${DEVICE}3"
```

```bash { "name": "mount-luks", "tag": ["luks"], "interactive": true  }
export DEVICE="/dev/vda"

sudo mount /dev/mapper/root /mnt

sudo mkdir -p /mnt/boot
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

sudo swapon "${DEVICE}2"
```

## Install

```bash { "name": "install", "interactive": true  }
export FLAKE="./nix-config/flake.nix#alice"

sudo nixos-install --root /mnt --flake ${FLAKE}
```

## Setup user

```bash { "name": "user-passwd", "interactive": true  }
export COMMAND="passwd alice"

sudo nixos-enter --root /mnt -c "$COMMAND"
```

```bash { "name": "git-clone", "interactive": true  }
export USER="alice"

git clone https://github.com/cashewnuts/nixos-config.git "/mnt/home/${USER}/nix-config"
```
