#!/bin/sh
# FFmpegAVS2 build script
#
# Copyright (c) 2018~ Yiqun Xu
#               2018~ Falei Luo
#               2018~ VCL, NELVT, PKU

###############################
# Sync repositories
###############################
checkGitSources()
{
    echo ">>>>"
    echo " -------------------------------------------------------------------------- "
    echo " dir: $1 "
    echo " url: $2 "
    echo " -------------------------------------------------------------------------- "
    if [ ! -d $1 ]; then
        echo "$1 source not found, cloning"
        git clone $2 $1
        checkfail "$1 source: git clone failed"
    else
        echo "$1 source found!"
    fi
    echo "synchronizing sources..."
    curdir=$(pwd)
    cd $1
    git pull
    cd $curdir
    echo "success..."
}

###############################
## install pkg-config
#### for ubuntu
###############################
# sudo apt-get install pkg-config

# current dir
build_dir=`pwd`

# sync sources
checkGitSources FFmpegAVS2  https://github.com/pkuvcl/FFmpegAVS2.git
checkGitSources xavs2       https://github.com/pkuvcl/xavs2.git
checkGitSources davs2       https://github.com/pkuvcl/davs2.git

###############################
# build xavs2 encoder
###############################
echo "\033[33m start build xAVS2 encoder\033[0m"
cd xavs2/build/linux  # xAVS2 directory
./configure --prefix=$build_dir/avs2_lib \
            --enable-pic \
            --enable-shared
make -j8
make install
cd ../../../

###############################
# build davs2 decoder
###############################
echo "\033[33m start build dAVS2 decoder\033[0m"
cd davs2/build/linux  # dAVS2 directory
./configure --prefix=$build_dir/avs2_lib \
            --enable-pic \
            --enable-shared
make -j8
make install
cd ../../../

###############################
# build ffmpeg decoder
###############################
echo "\033[33m start build FFmpegAVS2\033[0m"
cd FFmpegAVS2
git checkout avs2
export PKG_CONFIG_PATH=$build_dir/avs2_lib/lib/pkgconfig
./configure \
  --prefix=$build_dir/avs2_lib \
  --enable-gpl \
  --enable-libxavs2 \
  --enable-libdavs2 \
  --enable-nonfree \
  --enable-shared \
  --enable-static

make -j8
make install
# tar -czvf ./ffmpeg_lib.tar.gz ./install
