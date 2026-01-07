# mDNS
{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.my.avahi.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true; # 名前解決の手順(nsswitch.conf)にmDNSを追加
      publish = {
        enable = true;
        addresses = true; # 自分のIPアドレスを公開
        domain = true; # ドメイン名を公開
        userServices = true;
      };
      # ファイアウォールで mDNS 用のポート(UDP 5353)を自動で開く
      openFirewall = true;
    };
  };
}
