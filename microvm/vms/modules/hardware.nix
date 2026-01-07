{ config, pkgs, ... }:

{
  # 1. ハードウェアアクセラレーション (OpenGL/Vulkan) の有効化
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # 32bitアプリも使う場合
  };

  # 2. VirtIO GPU ドライバーを明示的に指定
  services.xserver.videoDrivers = [ "virtio" ];

  # 3. KVM ゲスト用のユーティリティを有効化
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # クリップボード共有なども含めて安定させる

  environment.variables = {
    # 常に VirtIO 経由で描画するように強制 (mesa 側の混乱を防ぐ)
    "WLR_NO_HARDWARE_CURSORS" = "1"; # Wayland を使っている場合
    "GALLIUM_DRIVER" = "virgl"; # VirtIO-GPU (VirGL) を使用
  };
}
