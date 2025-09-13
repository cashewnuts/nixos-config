setup /mnt/data

```bash
# open
sudo systemd-cryptsetup attach store-data /dev/disk/by-uuid/c975cdfa-0bfd-4e42-a5fe-c00b2292d88a
# using systemd
sudo systemctl start /mnt/data
# using manual mount
sudo mount -t ext4 /dev/mapper/store-data /mnt/data
```

clean up /mnt/data

```bash
# using systemd
sudo systemctl stop /mnt/data
# using manual umount
sudo umount /mnt/data
# close
sudo systemd-cryptsetup detach store-data
```
