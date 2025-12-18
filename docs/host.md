# Host OS

## Setup

Virt Manager を使ってVMの管理するときのTipsを書いておく。

> domain: internal.vm
> Virt default network ip: 192.168.122.1

Virt Manager の default ネットワークで domain を設定する。
これで Virt Manager 上の DHCP サーバーで domain が割り振られ、`ping ${machineName}.internal.vm` で通信が可能になる。
設定後は `sudo virsh net-destroy default && sudo virsh net-start default` で再起動する。

```
<network connections="1">
  ...
  <domain name="internal.vm" localOnly="yes"/>
  <ip address="192.168.122.1" netmask="255.255.255.0">
    ...
  </ip>
</network>
```

次に NetworkManager を経由して dnsmasq サービスを起動する。

> /etc/resolv.conf を直接使って Virt Manager の DNS サービスを指定すると wifi 環境の場合、勝手に resolv.conf の内容が書き換わってしまうため、NetworkManagerを利用する。

```
$ cat /etc/NetworkManager/conf.d/localdns.conf
[main]
dns=dnsmasq
```

次に domain に合致するDNSクエリーを Virt Manager の DNSサービスに転送する設定を行う。

```
$ cat /etc/NetworkManager/dnsmasq.d/libvirt_dnsmasq.conf
server=/internal.vm/192.168.122.1
```

なお、VMのゲストOS上で `sudo hostnamectl set-hostname something.internal.vm` のコマンドによる設定が必要な場合もあるらしい。
試したところ、自分の環境では hostname がそのまま適用されており設定不要だった。

以上
