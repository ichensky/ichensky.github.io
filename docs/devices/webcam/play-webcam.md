# Play webcam


### Play localy
```sh
$ mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 30

$ dd if=/dev/video0 | mplayer tv://device=/dev/stdin
```


### Play from remote PC
```sh
$ ssh 10.8.0.30 ffmpeg -an -f video4linux2 -s 640x480 -i /dev/video0 -r 10 -b:v 500k -f matroska - | mplayer - -idle
```

### Play from remote PC using netcat

#### on remoter PC:
```sh
$ ffmpeg -an -f video4linux2 -s 640x480 -i /dev/video0 -r 10 -b:v 500k -f matroska - | nc -l 10.8.0.14 1234
```

#### on local PC: 
```sh
$ nc 10.8.0.14 1234 | mplayer - -idle
```

### Stream webcam to remote PC:

#### on local PC:

###### create ssh tunel:
```sh
$ ssh -R 9000:localhost:1234 ichensky@78.46.154.97 -p 21002

stream webcam: 

$ ffmpeg -an -f video4linux2 -s 640x480 -i /dev/video0 -r 10 -b:v 500k -f matroska - | nc -l 127.0.01 1234
```

#### on remote PC:
```sh
$ nc 127.0.0.1 | ./mplayer.exe - -idle 
```
	



## Create rpt stream (upd stream)
```sh
$ ffmpeg -an -i /dev/video0 -f rtp rtp://localhost:1234
```
or
```sh
$ ffmpeg -i /dev/video0 -f mpegts udp://127.0.0.1:1234
```
