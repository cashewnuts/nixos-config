setup /mnt/data

```bash { "name": "mount-data" }
export TARGET="/dev/disk/by-uuid/c975cdfa-0bfd-4e42-a5fe-c00b2292d88a"
# open
sudo systemd-cryptsetup attach store-data $TARGET
# make dir
sudo mkdir -p /mnt/data
# using systemd
sudo systemctl start /mnt/data
# using manual mount
sudo mount -t ext4 /dev/mapper/store-data /mnt/data
```

clean up /mnt/data

```bash { "name": "umount-data" }
# using systemd
sudo systemctl stop /mnt/data
# using manual umount
sudo umount /mnt/data
# close
sudo systemd-cryptsetup detach store-data
```
