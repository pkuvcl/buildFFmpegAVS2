#!/bin/sh
# FFmpegAVS2 build script
#
# Copyright (c) 2018~ Yiqun Xu
#               2018~ Falei Luo
#               2018~ Huiwen Ren
#               2018~ VCL, NELVT, PKU

###############################
# Sync repositories
###############################

touch build.log
echo "BUILD TIME: $(date +%Y-%m-%d)" > build.log

if test -t 1 && which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
    if test -n "$ncolors" && test $ncolors -ge 8; then
        msg_color=$(tput setaf 3)$(tput bold)
        error_color=$(tput setaf 1)$(tput bold)
        reset_color=$(tput sgr0)
    fi
    ncols=$(tput cols)
fi

checkfail()
{
    echo "$error_color""ERROR: $@ failed.$reset_color"
    exit 1
}

printLog()
{
    echo ">>> $@" >> $build_dir/build.log
    $@ >> $build_dir/build.log
}

checkGitSources()
{
    echo ">>>>"
    echo " -------------------------------------------------------------------------- "
    echo " dir: $1 "
    echo " url: $2 "
    echo " -------------------------------------------------------------------------- "
    if [ ! -d $1 ]; then
        echo "$1 source not found, cloning"
        git clone $2 $1  || checkfail "$1 source: git clone failed"
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
echo "$msg_color[Start building xAVS2 encoder]$reset_color"
cd xavs2/build/linux  # xAVS2 directory
printLog ./configure --prefix=$build_dir/avs2_lib \
            --enable-pic \
            --enable-shared
printLog make -j8 || checkfail "make failed"
printLog make install
cd -

###############################
# build davs2 decoder
###############################
echo "$msg_color[Start building dAVS2 decoder]$reset_color"
cd davs2/build/linux  # dAVS2 directory
printLog ./configure --prefix=$build_dir/avs2_lib \
            --enable-pic \
            --enable-shared
printLog make -j8 || checkfail "make failed"
printLog make install
cd -

###############################
# build ffmpeg decoder
###############################
echo "$msg_color[Start building FFmpegAVS2]$reset_color"
cd FFmpegAVS2
git checkout avs2
export PKG_CONFIG_PATH=$build_dir/avs2_lib/lib/pkgconfig
printLog ./configure \
  --prefix=$build_dir/avs2_lib \
  --enable-gpl \
  --enable-libxavs2 \
  --enable-libdavs2 \
  --enable-shared \
  --enable-static

printLog make -j8 || checkfail "make failed"
printLog make install
# tar -czvf ./ffmpeg_lib.tar.gz ./install
cd -

echo "Everything done!"
