# Disable Beaglebone Black flashing heartbeat LED


### Temporary disable (till reboot):

```sh
echo none > /sys/class/leds/beaglebone\:green\:usr0/trigger
echo none > /sys/class/leds/beaglebone\:green\:usr1/trigger
echo none > /sys/class/leds/beaglebone\:green\:usr2/trigger
echo none > /sys/class/leds/beaglebone\:green\:usr3/trigger
```

### Persistently (permanently) disable: 

```sh
crontab -e
```

```sh
@reboot ...
```
