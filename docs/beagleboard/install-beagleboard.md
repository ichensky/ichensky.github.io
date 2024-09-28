# Install beagleboard

## Factory reset

1. Write img to SD Card.
 `am335x-eMMC-flasher-debian-11.7-iot-armhf-2023-09-02-4gb.img`

3. Hold S2 button and plug power supply

4. Wait until the device is flashed and powered off.

5. Remove SD Card



## Install to ssd. 

1. Write img to SD Card.
`am335x-debian-11.7-iot-armhf-2023-09-02-4gb.img`

3. Press "S2" button(not S3-power button), that is near SD Card and plug power supply.

4. ```ssh debian@192.168.7.2```

5. Check distro version: lsb_release -a

6. Expand sd card space: 

```sh
$ sh beaglebone_grow_partition.sh
```

[!code-sh[](beaglebone_grow_partition.sh)]
