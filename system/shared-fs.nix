{ config, lib, pkgs, modulesPath, ... }:

{
  fileSystems."/var/shared" =
    { device = "virtio_shared";
      fsType = "virtiofs";
    };
}

