#!/bin/bash

cd /home

rootpath=$(pwd)
sourcePath=$rootpath/src
crossEnvPath=/opt/cross-env
toolchain=/opt/FriendlyARM/toolchain/6.4-aarch64/

buildFFmpeg() {
	echo "start build ffmpeg aarch64 version"
	cd $sourcePath
	rm -rf ffmpeg
	tar -zxf ffmpeg-n4.1.5.tar.gz
	cd ffmpeg
	./configure \
		--prefix=/opt/FriendlyARM/toolchain/6.4-aarch64 \
		--disable-static --enable-shared --disable-x86asm \
		--enable-cross-compile --arch=aarch64 --target-os=linux --cross-prefix=aarch64-linux- \
		--enable-pthreads --enable-avresample --enable-ffplay
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

	export PKG_CONFIG_PATH=$toolchain/lib/pkgconfig:$PKG_CONFIG_PATH
	export PKG_CONFIG_LIBDIR=$toolchain/lib/pkgconfig:$PKG_CONFIG_LIBDIR

	cmake \
		-DOPENCV_FFMPEG_SKIP_BUILD_CHECK=ON \
		-DCMAKE_INSTALL_PREFIX=$crossEnvPath/opencv41 \
		-DCMAKE_TOOLCHAIN_FILE=$sourcePath/opencv/platforms/linux/aarch64-gnu.toolchain.cmake \
		-DARM_LINUX_SYSROOT=${toolchain} \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CXX_FLAGS="-O2 -pipe -w -Wl,-rpath,${toolchain}/lib" \
		-DCMAKE_EXE_LINKER_FLAGS="-lpthread -lrt -ldl" \
		..
	make -j8 && make install
}

# buildFFmpeg

buildOpenCV

