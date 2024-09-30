# Build `OpenWrt` image from sources

### Update packages
```sh
scripts/feeds update -a
scripts/feeds install -a
```

### Image Configuration
```sh
make menuconfig
make defconfig
make menuconfig
```

### Make 
```sh
make s=V
```

### Copy image
```sh
scp xxx.bin root@192.168.1.1:/tmp/
sysupgrade /tmp/xxx.bin 
```
