#!/bin/sh

username=john
servername=workvpn
clientname=$(echo $servername)_client

tmpdir=$PWD/tmp
dumpdir=$tmpdir/$clientname

rm -rf $dumpdir
mkdir -p $dumpdir

cd /etc/openvpn/easy-rsa

./easyrsa gen-req $clientname nopass
./easyrsa sign-req client $clientname

cp /etc/openvpn/easy-rsa/pki/issued/$clientname.crt \
   /etc/openvpn/easy-rsa/pki/private/$clientname.key \
   $dumpdir/
cp /etc/openvpn/ta.key $dumpdir/$servername.ta.key
cp /etc/openvpn/ca.crt $dumpdir/$servername.ca.crt

cat /usr/share/doc/openvpn/examples/sample-config-files/client.conf > \
	$dumpdir/$clientname.conf

sed -i -e "s/;user nobody/user nobody/" \
        -e "s/;group nogroup/group nogroup/" \
        -e "s/tls-auth ta.key 1/tls-auth $servername.ta.key 1/" \
        -e "s/ca ca.crt/ca $servername.ca.crt/" \
        -e "s/cert client.crt/cert $clientname.crt/" \
        -e "s/key client.key/key $clientname.key/" \
	$dumpdir/$clientname.conf



chown $username:$username $tmpdir -R
