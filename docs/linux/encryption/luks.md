# Luks

### CLEAN DISK
```sh
dd if=/dev/urandom of=/dev/sdx bs=4k
```

### FILESYSTEM PREPARETION
```sh
fdisk /dev/sdx
```
1. Create partition 0-2048 (may be bootable)
2. Create next partition 
3. ```w```

### FILESYSTEM ENCRIPTION
```sh
cryptsetup luksFormat /dev/sdx1 --key-size 512
```

### CREATING FILESYSTEM
```sh
cryptsetup open /dev/sdx1 sdx1_crypt
mkfs -t ext4 /dev/mapper/sdx1_crypt
```

### MOUNT ENCRYPTED FILESYSTEM
```sh
mount /dev/mapper/sdx1_crypt /mnt/tmp3
chown john:john /mnt/tmp3	
```

