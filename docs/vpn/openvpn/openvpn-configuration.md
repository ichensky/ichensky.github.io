# `Openvpn` configuration



## Server
#### Server installation
```sh
$ apt install openvpn easy-rsa
```

#### Certificate Authority Setup
```sh
$ make-cadir /etc/openvpn/easy-rsa
$ cd /etc/openvpn/easy-rsa
$ ./easyrsa gen-dh
$ ./easyrsa init-pki
$ ./easyrsa build-ca nopass
```

#### Server Keys and Certificates
```sh
$ ./easyrsa gen-dh
$ ./easyrsa gen-req myservername nopass
$ ./easyrsa sign-req server myservername
$ cp pki/dh.pem pki/ca.crt \
	pki/issued/myservername.crt \
	pki/private/myservername.key \
	/etc/openvpn/
```

#### Client Certificate (for server)
```sh
$ ./easyrsa gen-req myclient nopass
$ ./easyrsa sign-req client myclient
```

#### Simple Server Configuration
```sh
$ gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/myserver.conf
```

#### Edit /etc/openvpn/myserver.conf
```
ca ca.crt
cert myservername.crt
key myservername.key
dh dh.pem

user nobody
group nogroup
```

#### Gen ta key
```sh
$ cd /etc/openvpn
$ openvpn --genkey --secret ta.key
```

#### Validate myserver.conf file
```sh
$ openvpn /etc/openvpn/myserver.conf	
```

#### Edit /etc/sysctl.conf and uncomment
```
#net.ipv4.ip_forward=1
```

#### Then reload sysctl
```sh
$ sysctl -p /etc/sysctl.conf 
```

#### Start openvpn
```sh
$ systemctl enable openvpn@myserver
$ systemctl start openvpn@myserver
```

#### To view logs
```sh
$ journalctl -u openvpn@myserver -xe
```

#### Check if OpenVPN created a tun0 interface
```sh
$ ip addr show dev tun0
```


## Client

#### Simple Client Configuration
```sh
$ apt install openvpn

$ cat /usr/share/doc/openvpn/examples/sample-config-files/client.conf > /etc/openvpn/myclient.conf
```

#### Copy client keys from server

```
ca ca.crt
cert myclient1.crt
key myclient1.key
tls-auth ta.key 1
```

#### Edit myclient.conf

```
client
remote vpnserver.example.com 1194
```

#### Start openvpn
```sh
$ systemctl start openvpn@client
```

#### Check on the client if it created a tun0 interface
```sh
$ ip addr show dev tun0
```

#### Check it you can ping the OpenVPN server
```sh
$ ping 10.8.0.1
```

#### Check out your routes
```sh
$ ip route
```

---
Script to configure Server
[!code-sh[](gen_server.sh)]

Script to configure Client
[!code-sh[](gen_client.sh)]

Script to add route at client
[!code-sh[](add_route_at_client.sh)]

Script to test with `tcpdump`
[!code-sh[](test.tcpdump.sh)]

