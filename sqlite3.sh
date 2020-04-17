#!/bin/bash

cd /home

rootpath=$(pwd)
sourcePath=$rootpath/src
crossEnvPath=/opt/cross-env
toolchain=/opt/FriendlyARM/toolchain/6.4-aarch64/

buildSqlite3() {
	echo "start build sqlite3 aarch64 version"
	cd $sourcePath
	rm -rf sqlite-autoconf-3310100
	tar -zxf sqlite-autoconf.tar.gz	
	cd sqlite-autoconf-3310100
	./configure CC=aarch64-linux-gnu-gcc --prefix=$crossEnvPath/sqlite3 --host=aarch64-linux --build=aarch64-arm-linux-gnu
	make -j8 && make install
}

buildSqlite3

