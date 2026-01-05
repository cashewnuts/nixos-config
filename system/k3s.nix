{
  config,
  lib,
  pkgs,
  ...
}:
let
  serverIp = lib.optionals (config.k3s.ip != null) [
    "--node-ip=${config.k3s.ip}"
    "--node-external-ip=${config.k3s.ip}"
    # "--bind-address=${config.k3s.ip}"
  ];
  # config.services.k3s ではなく、自前で定義した config.k3s を参照
  sanList =
    (lib.optional (config.k3s.fqdn != null) config.k3s.fqdn)
    ++ (lib.optional (config.k3s.ip != null) config.k3s.ip)
    ++ [ ];

  tlsSanArg = lib.optional (sanList != [ ]) "--tls-san=${lib.concatStringsSep "," sanList}";
in
{
  options.k3s = {
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

  config = {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = [
        # 必要に応じて Traefik などを無効化
        # "--disable traefik"

        # etcdのタイムアウトを引き伸ばして virtiofs の問題を緩和
        "--etcd-arg=election-timeout=6000"
        "--etcd-arg=heartbeat-interval=1000"
      ]
      ++ serverIp
      ++ tlsSanArg;
    };

    # ホストからの通信を許可
    networking.firewall = {
      allowedTCPPorts = [
        6443 # k8s API Server
        2379 # etcd client port (マルチノードの場合)
        2380 # etcd peer port (マルチノードの場合)
      ];
      allowedUDPPorts = [
        8472 # flannel VXLAN
      ];
    };

    # kubeconfig のパーミッションを調整（取り出しやすくするため）
    systemd.services.k3s.serviceConfig.ExecStartPost = [
      "${pkgs.coreutils}/bin/chmod 644 /etc/rancher/k3s/k3s.yaml"
    ];

    # 必要に応じてパッケージを追加
    environment.systemPackages = with pkgs; [
      #
    ];
  };
}
