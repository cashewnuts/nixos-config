setup /mnt/data

```bash
sudo systemd-cryptsetup attach store-data /dev/disk/by-uuid/c975cdfa-0bfd-4e42-a5fe-c00b2292d88a
sudo systemctl start /mnt/data
```

clean up /mnt/data

```bash
sudo systemctl stop /mnt/data
sudo systemd-cryptsetup detach store-data
```
