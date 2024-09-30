# Install `OpenWrt` image

#### Statistics, which devices are popular
https://downloads.openwrt.org/stats/

#### If device is supported by OpenWrt
https://openwrt.org/toh/start

#### Download OpenWrt Firmware for your Device
https://firmware-selector.openwrt.org/


##### In 2022-2023 popular device: ASUS RT-AX1800U 
https://openwrt.org/toh/asus/rt-ax53u



### Customize installed packages and/or first boot script include packaged into build


#### Packages: 

#### package for automatic sys-upgrade
[url](https://www.youtube.com/watch?v=FFTPA6GkJjg)

##### UI version: 
```
luci-app-attendedsysupgrade
```
##### Console version:
```
auc
```

#### Net statistics
```
netdata
```
view: http://192.168.1.1:19999/





### Disable rebind_protection
https://openwrt.org/docs/guide-user/base-system/dhcp
```sh
$ rebind_protection

config dnsmasq
        option rebind_protection '0'

$ service dnsmasq restart
```
#### With UI

>> Network >> DHCP and DNS >> General Settings >> Rebind protection
http://192.168.1.1/cgi-bin/luci/admin/network/dhcp
