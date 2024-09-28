# Build package from source

* Download a source package
```sh
$ apt-get source packagename
```

* To auto-build the package when it's been downloaded:
```sh
$ apt-get -b source packagename
```

* If you decide not to create the .deb at the time of the download, you can create it later by running:
```sh
$ dpkg-buildpackage -rfakeroot -uc -b
```

* To install package: 
```sh
$ dpkg -i file.deb
```

### Packages needed for compiling a source package
```sh
$ apt-get build-dep packagename
```

