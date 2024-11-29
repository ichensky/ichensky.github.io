# Mifare Classic 1k

### Check which sectors can be decoded with default keys

```sh
$ hf mf chk
```


```txt
[usb] pm3 --> hf mf chk
[+] loaded 61 hardcoded keys
[=] Start check for keys...
[=] .................................
[=] time in checkkeys 4 seconds

[=] testing to read key B...

[+] found keys:

[+] -----+-----+--------------+---+--------------+----
[+]  Sec | Blk | key A        |res| key B        |res
[+] -----+-----+--------------+---+--------------+----
[+]  000 | 003 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  001 | 007 | ------------ | 0 | ------------ | 0 
[+]  002 | 011 | ------------ | 0 | ------------ | 0 
[+]  003 | 015 | ------------ | 0 | ------------ | 0 
[+]  004 | 019 | ------------ | 0 | ------------ | 0 
[+]  005 | 023 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  006 | 027 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  007 | 031 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  008 | 035 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  009 | 039 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  010 | 043 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  011 | 047 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  012 | 051 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  013 | 055 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  014 | 059 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+]  015 | 063 | FFFFFFFFFFFF | 1 | FFFFFFFFFFFF | 1 
[+] -----+-----+--------------+---+--------------+----
[+] ( 0:Failed / 1:Success )

```

Data in sector `000` from block `000` to `003` encrypted with key `FFFFFFFFFFFF`.

Data in sector `001` from block `004` to `007` encrypted with `unknown` key.

### Decrypt with keys 
1. Create file `abc.dic` with keys
2. Try to decrypt data

```sh
$ hf mf chk -f home.dic
```

### Autodecrypt 
```sh
hf mf autopwn
```
