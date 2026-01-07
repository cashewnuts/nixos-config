{
  lib,
  impermanence,
  pkgs,
  username,
  index,
  ...
}:
{
  # It is highly recommended to share the host's nix-store
  # with the VMs to prevent building huge images.
  microvm = {
    optimize.enable = false;
    vcpu = 4;
    mem = 6144;
    hugepageMem = 6144;

    qemu.extraArgs = [
      # GPU
      "-device"
      "virtio-gpu-gl,blob=on,venus=off,hostmem=2G"
      "-display"
      "egl-headless"
      "-vga"
      "none"
      # AUDIO
      "-audiodev"
      "driver=pipewire,id=audio1,out.latency=30000,out.buffer-length=60000,in.latency=30000,in.buffer-length=60000"
      "-device"
      "ich9-intel-hda"
      "-device"
      "hda-duplex,audiodev=audio1"
    ];

    interfaces = [
      {
        type = "tap";
        id = "mvm-${username}";
        mac = "02:00:00:00:00:${index}";
      }
    ];

    devices = [
      {
        # Dummy for usb
        # https://github.com/microvm-nix/microvm.nix/blob/f4ae3dc4ee4c9b585b03c36bd73ef68d2a8eb3a9/lib/runners/qemu.nix#L64
        bus = "usb";
        path = "";
      }
    ];

    shares = [
      {
        proto = "virtiofs";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        readOnly = true;
      }
      {
        proto = "virtiofs";
        tag = "persist";
        # Source path can be absolute or relative
        # to /var/lib/microvms/$hostName
        source = "/var/lib/microvms/.persist";
        mountPoint = "/persist";
      }
    ];
  };

  services.udev.extraRules = ''
    # 特定の HID デバイスの権限を 0666 にする
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="9470", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="9470", MODE="0666"
  '';

  users.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTlpccJLaR57c6RJ2GO/p/nFFjFhB6W2tIBRymOdkCP steav@main"
  ];

  # Any other configuration for your MicroVM
  imports = [
    impermanence.nixosModules.impermanence
    ./modules/hardware.nix
    ./modules/network.nix
    ./user/graham.nix
    ../../options.nix
    ../../system
  ];

  my = {
    fonts.enable = true;
    avahi.enable = true;
    openssh = {
      enable = true;
      secure = false;
    };
    waypipe.enable = true;
    firefox = {
      enable = true;
      type = "private";
    };
  };

  # Graphics
  hardware.graphics.enable = true;
  # Wayland アプリを headless で動かすために必要
  environment.variables = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  services.pipewire = {
    enable = true;
    systemWide = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    alsa-utils # aplay
    pulseaudio # pactl
    pciutils
  ];
  environment.etc."wireplumber/wireplumber.conf.d/50-default-volume.conf".text = ''
    wireplumber.settings = {
      device.routes.default-sink-volume = 1.0
    }
  '';

  fileSystems."/persist".neededForBoot = lib.mkForce true;
  environment.persistence."/persist" = {
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/home/${username}/.zshrc"
      "/home/${username}/.zsh_history"
    ];
  };
}
