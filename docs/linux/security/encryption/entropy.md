# Entropy

On modern Linux kernels (5.10+) `entropy_avail` will normally return 256 (bits), which tells you that you can get a 256-bit random number from `/dev/[u]random`, and that it will probably take, on average, 2^255 guesses to crack it.

> A read from the `/dev/urandom` device will not block waiting for more entropy. As a result, if there is not sufficient entropy in the entropy pool, **the returned values are theoretically vulnerable to a cryptographic attack on the algorithms** used by the driver. If this is a concern in your application, use `/dev/random` instead.
[https://linux.die.net/man/4/random](https://linux.die.net/man/4/random)


* Get current entropy level
```sh
cat /proc/sys/kernel/random/entropy_avail
```


* Improve entropy level 
```sh
apt-get install rng-tools
rngd -r /dev/urandom
```