{ config, pkgs, ... }:
{
  # systemd-networkd と resolved を有効化
  systemd.network.enable = true;
  services.resolved.enable = true;

  # すべてのイーサネットインターフェースに対するデフォルト設定
  systemd.network.networks."99-default-ethernet" = {
    # 名前が "en" で始まるすべてのインターフェースにマッチさせる
    matchConfig.Name = "en*";

    networkConfig = {
      DHCP = "yes";
      DNSDefaultRoute = true;
      # IPv6の自動設定(RA)も有効にするなら
      IPv6AcceptRA = true;
    };

    dhcpV4Config = {
      UseDNS = true;
      UseRoutes = true;
    };
  };

  # 既存の global DHCP 設定と衝突しないようにオフにする
  networking.useDHCP = false;
}
