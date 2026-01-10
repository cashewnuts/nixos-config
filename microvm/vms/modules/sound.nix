{ lib, config, ... }:
{
  config = lib.mkIf config.my.microvm.sound.enable {
    microvm.qemu.extraArgs = [
      # AUDIO
      "-audiodev"
      "driver=pipewire,id=audio1,out.latency=30000,out.buffer-length=60000,in.latency=30000,in.buffer-length=60000"
      "-device"
      "ich9-intel-hda"
      "-device"
      "hda-duplex,audiodev=audio1"
    ];
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
    environment.etc."wireplumber/wireplumber.conf.d/50-default-volume.conf".text = ''
      wireplumber.settings = {
        device.routes.default-sink-volume = 1.0
      }
    '';
  };
}
