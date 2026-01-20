{ lib, ... }:
{
  options.my = {
    appimage = {
      enable = lib.mkEnableOption "Enable AppImage";
    };
    avahi = {
      enable = lib.mkEnableOption "Enable";
    };
    cloud-hypervisor = {
      enable = lib.mkEnableOption "Enable";
    };
    fcitx5 = {
      enable = lib.mkEnableOption "Enable";
    };
    firefox = {
      enable = lib.mkEnableOption "Enable firefox";
      type = lib.mkOption {
        type = lib.types.enum [
          "private"
          "home"
          "developer"
        ];
        default = "home";
        description = "実行環境を選択します。";
      };
    };
    flatpak = {
      enable = lib.mkEnableOption "Enable";
    };
    fonts = {
      enable = lib.mkEnableOption "Enable";
    };
    hyprland = {
      enable = lib.mkEnableOption "Enable";
    };
    k3s = {
      enable = lib.mkEnableOption "Enable";
      fqdn = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "FQDN for K3s TLS SAN";
      };
      ip = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "IP for K3s TLS SAN";
      };
    };
    libvirt = {
      enable = lib.mkEnableOption "Enable";
    };
    networkmanager = {
      enable = lib.mkEnableOption "Enable";
    };
    openmosh = {
      enable = lib.mkEnableOption "Enable";
    };
    openssh = {
      enable = lib.mkEnableOption "Enable";
      secure = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether disallow password authentication or not.
        '';
      };
    };
    ssh = {
      enable = lib.mkEnableOption "Enable";
    };
    stub-ld = {
      enable = lib.mkEnableOption "Enable";
    };
    waypipe = {
      enable = lib.mkEnableOption "Enable";
    };
  };
}
