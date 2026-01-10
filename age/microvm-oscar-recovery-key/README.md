---
created: 2026-01-10
---

# LUKSリカバリーキー

## 暗号化/復号/展開

```
# 暗号化
$ tar cvz microvm-oscar-recovery-key.* | age -r age1wts2kxfxajgu8xmhj2434hjhzj3fwksagvt88qypfkqy7jf84yxs8ll54k > microvm-oscar-recovery-key.tar.gz.age
# 復号
$ age --decrypt -i [key.txt] microvm-oscar-recovery-key.tar.gz.age > microvm-oscar-recovery-key.tar.gz
# 展開
$ tar xvf microvm-oscar-recovery-key.tar.gz
```

## 使用方法

```
# リカバリーキーの確認（wl-copyを使ってもいい）
$ cat microvm-oscar-recovery-key.txt
# 復号化
$ sudo cryptsetup open /dev/vg01/microvm-oscar microvm-oscar
passphrase: <- リカバリーキーを入力 or paste
# Mount
$ sudo mount /dev/mapper/microvm-oscar /mnt/oscar
```
