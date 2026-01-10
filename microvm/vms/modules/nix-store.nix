{ lib, config, ... }:
let
  cfg = config.my.microvm.nix-store;
in
{
  config = lib.mkIf cfg.enable {
    microvm = {
      shares = [
        {
          proto = "virtiofs";
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          readOnly = true;
        }
      ];
      writableStoreOverlay = if (cfg.writableImage != "") then "/nix/.rw-store" else null;
      volumes = lib.mkIf (cfg.writableImage != "") [
        {
          fsType = "ext4";
          autoCreate = false;
          image = cfg.writableImage;
          mountPoint = "/nix/.rw-store";
        }
      ];
    };
  };
}
