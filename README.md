# Instruction of AVS2 encoder and decoder for FFmpeg

## Build the FFmpeg library with AVS2
Use `build_linux.sh` to build and follow the output.

## test
Encoding a YUV file.
```
./ffmpeg -pix_fmt yuv420p -s 1920x1080 -r 50 -i /work/Seq/BasketballDrive_1920x1080_50.yuv -vcodec libxavs2 -b:v 5000k -y test.avs2
```
Decoding an AVS2 ES file.
```
./ffmpeg -vcodec libdavs2 -vsync vfr -i test.avs2 -y dec.yuv
```

## Report a Bug
 
 Please [make a issue in github][10] and provide us the operations to reproduce it.

## Homepages

[PKU-VCL][1]

`AVS2-P2/IEEE1857.4` Encoder: [xavs2 (Github)][2], [xavs2 (mirror in China)][3]

`AVS2-P2/IEEE1857.4` Decoder: [davs2 (Github)][4], [davs2 (mirror in China)][5]

`FFmpegAVS2` FFmpeg with AVS2 support:  [FFmpegAVS2 (Github)][6], [FFmpegAVS2 (mirror in China)][7]

`buildFFmpegAVS2`: [build script of FFmpegAVS2 (Github)][8], [build script of FFmpegAVS2 (mirror in China)][9]

  [1]: http://vcl.idm.pku.edu.cn/ "PKU-VCL"
  [2]: https://github.com/pkuvcl/xavs2 "xavs2 github repository"
  [3]: https://gitee.com/pkuvcl/xavs2 "xavs2 gitee repository"
  [4]: https://github.com/pkuvcl/davs2 "davs2 decoder@github"
  [5]: https://gitee.com/pkuvcl/davs2 "davs2 decoder@gitee"
  [6]: https://github.com/pkuvcl/FFmpegAVS2 "FFmpegAVS2@github"
  [7]: https://gitee.com/pkuvcl/FFmpegAVS2  "FFmpegAVS2@gitee"
  [8]: https://github.com/pkuvcl/buildFFmpegAVS2 "FFmpegAVS2 build script @ github"
  [9]: https://gitee.com/pkuvcl/buildFFmpegAVS2  "FFmpegAVS2 build script @ gitee"
  [10]: https://github.com/pkuvcl/buildFFmpegAVS2/issues "FFmpegAVS2 build issue"
