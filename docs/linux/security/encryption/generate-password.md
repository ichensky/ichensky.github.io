# Generate password

```sh
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32;echo;
```