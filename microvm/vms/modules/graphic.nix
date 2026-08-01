{ lib, config, ... }:
{
  config = lib.mkIf config.my.microvm.graphic.enable {
    microvm.qemu.extraArgs = [
      # GPU
      "-device"
      "virtio-gpu-gl,blob=on,venus=on,hostmem=2G"
      "-display"
      "egl-headless"
      "-vga"
      "none"
    ];

    # Graphics
    hardware.graphics.enable = true;
    # Wayland アプリを headless で動かすために必要
    environment.variables = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };
}
