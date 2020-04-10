#!/bin/bash

cd /home

rootpath=$(pwd)
sourcePath=$rootpath/src

crossEnvPath=/opt/cross-env

toolchain=/opt/FriendlyARM/toolchain/6.4-aarch64/


buildSqlite3() {
	echo "start build sqlite3 aarch64 version"
	cd $rootpath
	rm -rf sqlite-autoconf
	tar -zxf sqlite-autoconf.tar.gz	
	cd sqlite-autoconf
	./configure CC=aarch64-linux-gnu-gcc --prefix=$toolchain/usr/sqlite3 --host=aarch64-linux --build=aarch64-arm-linux-gnu
	make -j8 && make install
}

buildFFmpeg() {
	echo "start build ffmpeg aarch64 version"
	cd $sourcePath
	rm -rf ffmpeg
	tar -zxf ffmpeg-n4.1.5.tar.gz
	cd ffmpeg
	./configure \
		--prefix=/opt/cross-env/ffmpeg \
		--disable-static --enable-shared --disable-x86asm \
		--enable-cross-compile --arch=aarch64 --target-os=linux --cross-prefix=aarch64-linux- \
		--enable-pthreads --enable-avresample --enable-ffplay
	make -j8 && make install
}

buildLibevent() {
	cd $rootpath
	rm -rf libevent
	tar -zxf libevent-2.1.11-stable.tar.gz
	cd libevent-2.1.11-stable
	./configure \
		--with-sysroot=${toolchain} \
		--disable-static \
		--enable-shared \
		--enable-cross-compile 

	make -j8 && make install
}

buildOpenCV(){
	cd $sourcePath
	rm -rf opencv
	tar -zxf opencv-4.1.2.tar.gz
	# 编译opencv
	cd opencv 

	# 创建输出目录
	rm -rf build && mkdir build && cd build

	apt-get install -y cmake pkg-config

	export PKG_CONFIG_PATH=$crossEnvPath/ffmpeg/lib/pkgconfig/:$PKG_CONFIG_PATH
	export PKG_CONFIG_LIBDIR=$crossEnvPath/ffmpeg/lib/pkgconfig/:$PKG_CONFIG_LIBDIR

	cmake \
		-DCMAKE_INSTALL_PREFIX=$crossEnvPath/opencv41 \
		-DCMAKE_TOOLCHAIN_FILE=$sourcePath/opencv/platforms/linux/aarch64-gnu.toolchain.cmake \
		-DARM_LINUX_SYSROOT=${toolchain} \
		-DCMAKE_CXX_FLAGS="-O2 -pipe -w -Wl,-rpath,${crossEnvPath}/ffmpeg/lib" \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_EXE_LINKER_FLAGS="-lpthread -lrt -ldl" \
		..
	# make -j8 && make install
}

buildWiringPi() {
	cd $rootpath
	WiringPiVersion=WiringPi-final_official_2.50

	rm -rf $WiringPiVersion
	tar -zxf $WiringPiVersion.tar.gz

	cd $WiringPiVersion
	

}

# buildFFmpeg

buildOpenCV

