{ lib, config, ... }:
let
  graphic = config.my.microvm.graphic;
in
{
  config = lib.mkIf graphic.enable {
    # microvm.qemu.extraArgs = [
    #   # GPU
    #   "-device"
    #   "virtio-gpu-gl,blob=on,venus=on,hostmem=2G,drm_native_context=on"
    #   "-display"
    #   "egl-headless"
    #   "-vga"
    #   "none"
    # ];
    microvm.graphics = {
      enable = true;
      backend = "headless";
      hostmem = graphic.hostmem;
      vulkan = "drm_native_context";
    };

    # Graphics
    hardware.graphics.enable = true;
    # Wayland アプリを headless で動かすために必要
    environment.variables = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };
}
