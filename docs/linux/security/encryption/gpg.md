# GPG

### Encrypt file
```sh
gpg --symmetric --personal-cipher-preferences 'AES256' FILE.TXT
```

### Decrypt file
```sh
gpg --decrypt x.zip.gpg > x.zip
```

### Generate password
```sh
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c96;echo;
```


### Export keys
```sh
gpg --list-keys
gpg --armor --export C1788E7F > C1788E7F.armor
gpg --export C1788E7F > C1788E7F.pub
gpg --export-secret-key C1788E7F > C1788E7F.asc
```
