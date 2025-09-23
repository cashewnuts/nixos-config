Setup memo

## Install utils

```
# apt install \
  vim \
  neovim \
  zsh \
  git \
  kitty-terminfo \
  fzf \
  fd-find \
  ripgrep
```

## user management

```
# useradd -m -s /bin/zsh ${username}
```

## ssh setup

### Install sshd

```
# apt install openssh-server

# systemctl enable --now ssh
```

### From ssh client

add ssh authorization_keys

```
$ ssh-copy-id [username]@debian.qxyz.vm
```

### Change server settings

- Disable password login

```
$ echo /etc/ssh/sshd_config
...
PasswordAuthentication no
KdbInteractiveAuthentication no
```

restart ssh service

```
# systemctl restart sshd
```

## nix setup

### Install and Add user to group

```
# apt install nix-setup-systemd

# usermod -aG nix-users [username]
```

### nix user settings - login with ssh

- clone nixos-config
- add nixpkgs channel
- install home-manager
- enable experimental-features
- add temporary $PATH

```
$ git clone https://github.com/cashewnuts/nixos-config
```

```
$ nix-channel --add https://nixos.org/channels/nixos-25.05 nixpkgs && nix-channel --update
```

```
$ nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```

```
$ mkdir -p ~/.config/nix
$ echo ~/.config/nix/nix.conf
experimental-features = nix-command flakes
```

```
export PATH="$HOME/.nix-profile/bin:$PATH"
```
