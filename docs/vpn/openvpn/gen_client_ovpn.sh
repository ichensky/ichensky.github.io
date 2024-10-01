#!/bin/sh

username=john
clientname=nameOFvpn_nameOFpc
ovpn=$PWD/$clientname.ovpn
remote="remote 52.188.72.234 443"

rm -rf $dumpdir
mkdir -p $dumpdir

cd /etc/openvpn/easy-rsa

./easyrsa gen-req $clientname nopass
./easyrsa sign-req client $clientname

cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf $ovpn

sed -i -e "s/;user nobody/user nobody/" \
        -e "s/;group nogroup/group nogroup/" \
        -e "s/tls-auth ta.key 1/key-direction 1/" \
        -e "s/ca ca.crt/;ca ca.crt/" \
        -e "s/cert client.crt/;cert client.crt/" \
        -e "s/key client.key/;key client key/" \
        -e "s/remote my-server-1 1194/$remote/" \
	$ovpn

echo "<tls-auth>" >> $ovpn
cat /etc/openvpn/ta.key >> $ovpn
echo "</tls-auth>" >> $ovpn

echo "<ca>" >> $ovpn
cat /etc/openvpn/ca.crt >> $ovpn
echo "</ca>" >> $ovpn

echo "<cert>" >> $ovpn
cat /etc/openvpn/easy-rsa/pki/issued/$clientname.crt >> $ovpn
echo "</cert>" >> $ovpn

echo "<key>" >> $ovpn
cat /etc/openvpn/easy-rsa/pki/private/$clientname.key  >> $ovpn
echo "</key>" >> $ovpn


chown $username:$username $ovpn
