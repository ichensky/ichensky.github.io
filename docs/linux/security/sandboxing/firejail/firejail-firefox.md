# `firejail` `firefox`

### Install display server `Xephyr`
```sh
$ apt-get install xerver-xephyr
```

### Install `firejail`
```sh
$ apt-get install firejail
```


### Run firefox
```sh	
$ firejail --x11=xephyr filrefox
```
