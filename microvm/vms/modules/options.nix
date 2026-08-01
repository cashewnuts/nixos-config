{ lib, ... }:
{
  options.my.microvm = {
    network = {
      enable = lib.mkEnableOption "Enable";
    };
    openssh = {
      enable = lib.mkEnableOption "Enable";
      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          openssh authorized keys for the user
        '';
      };
    };
    sound = {
      enable = lib.mkEnableOption "Enable";
    };
    graphic = {
      enable = lib.mkEnableOption "Enable";
      hostmem = lib.mkOption {
        type = lib.types.str;
        default = "256M";
        description = ''
          Size of the QEMU virtio-gpu host memory window, typically between 256M and 8G.
          The value must include a unit suffix (M or G).
        '';
      };
    };
    persistence = {
      enable = lib.mkEnableOption "Enable";
      source = lib.mkOption {
        type = lib.types.str;
        default = ""; # 初期値を空にする
        description = "persist source path";
      };
    };
    nix-store = {
      enable = lib.mkEnableOption "Enable";
      writableImage = lib.mkOption {
        type = lib.types.str;
        default = ""; # 初期値を空にする
        description = "Image path";
      };
    };
  };
}
