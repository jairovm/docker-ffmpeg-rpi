FROM resin/rpi-raspbian:jessie

RUN apt-get update \
    && apt-get install -y build-essential git wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone --depth 1 git://git.videolan.org/x264 \
    && cd x264 \
    && ./configure --host=arm-unknown-linux-gnueabi --enable-static --disable-opencl \
    && make -j 4 \
    && make install \
    && cd .. && rm -rf x264

RUN wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.tar.gz \
    && tar xzvf lame-3.99.tar.gz \
    && cd lame-3.99 \
    && ./configure \
    && make \
    && make install \
    && cd .. && rm -rf lame-3.99*

RUN apt-get update \
    && apt-get install -y cmake \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/raspberrypi/userland.git \
    && cd userland \
    && ./buildme \
    && cd .. && rm -rf userland

ENV LD_LIBRARY_PATH /opt/vc/lib

RUN apt-get update \
    && apt-get install -y pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git \
    && cd ffmpeg \
    && ./configure \
      --arch=armel \
      --target-os=linux \
      --enable-gpl \
      --enable-libx264 \
      --enable-libmp3lame \ 
      --enable-nonfree \
      --enable-omx \
      --enable-omx-rpi \
      --enable-mmal \
    && make -j4 \
    && make install \
    && ldconfig \
    && cd .. && rm -rf ffmpeg
