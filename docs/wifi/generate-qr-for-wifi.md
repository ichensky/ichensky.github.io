# Generate QR code for Wi-FI


### Prepare Wi-Fi information using the below format:

```
WIFI:S:{SSID name of your network};T:{security type - WPA or WEP};P:{the network password};;
```

### Generate QR:

```sh
$ cat file | qrencode -o mywifi.png
```

