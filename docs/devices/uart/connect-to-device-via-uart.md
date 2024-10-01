# Connect to the device via `UART`

`UART` is a peripheral device for asynchronous serial communication in which the data format and transmission speeds are configurable. [wiki](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)

### Check UART voltage: 3.3V vs 5V

### Connect UART

GRD - GRD
TX - RX
RX - TX

### Plug device

### Plug USB

### Check device connected: 
```sh 
$ lsusb
```

### Find tty:
```sh 
$ ls /dev/ | grep USB
```

### Connect to device
(Check: standard Baud Rates)


```sh 
$ screen ttyUSB0 115200

```

(As alternative see: picocom)

```sh 
picocom -b115200 /dev/ttyUSB0 
```



