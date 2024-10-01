#!/bin/sh

apt install openvpn easy-rsa

make-cadir /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa

./easyrsa gen-dh
./easyrsa init-pki
./easyrsa build-ca nopass

./easyrsa gen-dh
./easyrsa gen-req server nopass
./easyrsa sign-req server server


cp pki/dh.pem /etc/openvpn/dh2048.pem
cp pki/ca.crt \
  pki/issued/server.crt \
  pki/private/server.key \
  /etc/openvpn/

cd /etc/openvpn

gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > server.conf

sed -i -e "s/;user nobody/user nobody/" \
	-e "s/;group nogroup/group nogroup/" \
	-e "s/;client-to-client/client-to-client/" \
	server.conf

openvpn --genkey --secret ta.key

sed -i -e "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" \
	/etc/sysctl.conf 

sysctl -p /etc/sysctl.conf

systemctl enable openvpn@server
systemctl start openvpn@server

journalctl -u openvpn@server -xe
