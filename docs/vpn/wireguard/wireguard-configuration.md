# `wireguard` configuration

## 1. Install

```sh
apt-get install wireguard
```

## 2. Enable IP Forwarding at `server`

```sh
vim /etc/sysctl.conf
```

#### Edit:
```ini
net.ipv4.ip_forward=1
```

#### Apply
```sh
sysctl -p
```

## 3. Configure `ufw` (for Azure edit `network` firewall setting)
#### Unblock `ssh`, `wireguard` ports:

```sh
apt install ufw
ufw allow ssh
ufw allow 51820/udp
```

#### Enable firewall: 

```sh
ufw enable
```

#### Check status:

```sh
ufw status
```

## 4. Generate keys at `server` & `client`

```sh
cd /etc/wireguard
```

#### Remove permission:
```sh
umask 077
```

#### Generate keys:
```sh
wg genkey | tee privatekey | wg pubkey > publickey
```

## 5. Generate `server` config:

```sh
vim /etc/wireguard/wg0.conf
```

```ini
[Interface]
PrivateKey = <server private key>
Address = 10.8.0.1/24
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 51820

# client 1
[Peer]
PublicKey = <client public key>
AllowedIPs = 10.8.0.2/32

# client 2
[Peer]
PublicKey = <client public key>
AllowedIPs = 10.8.0.3/32

```

## 6. Generate `client` config:

```sh
vim /etc/wireguard/wg0.conf
```

```ini
[Interface]
Address = 10.8.0.2/32
PrivateKey = <client private key>

# server
[Peer]
PublicKey = <server public key>
Endpoint = server_IP_or_domain_name:51820
AllowedIPs = 10.8.0.0/24
PersistentKeepalive = 15
```

## 7. Enable wireguard, start as service 

```sh
systemctl start wg-quick@wg0
systemctl enable wg-quick@wg0
```

## 7. Start wireguard as process

```sh
wg-quick up wg0
```

## 8. To Check `wireguard` kernel module loaded:
```sh
modprobe wireguard
```

## 8. To check default interface name:

```sh
ip route list default
```

## 9. Generate QR code with keys:

```sh
apt install qrenconde
qrencode -t ansiutf8 wg-client.conf
```

Save as png:
```sh
qrencode -t png -o client-qr.png -r wg-client.conf
```

References: 

* https://www.wireguard.com/quickstart/
* https://upcloud.com/resources/tutorials/get-started-wireguard-vpn