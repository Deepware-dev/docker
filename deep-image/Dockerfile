# Name: deep-image
# Description: 
#
# VERSION       1.0
#

FROM ubuntu:18.04 AS base

FROM nvidia/cuda:10.2-devel AS nvidia

# RUN executes a shell command
# You can chain multiple commands together with && 
# A \ is used to split long lines to help with readability
# This particular instruction installs the source files 
# for deviceQuery by installing the CUDA samples via apt
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-samples-$CUDA_PKG_VERSION && \
    rm -rf /var/lib/apt/lists/*

FROM ros:melodic-ros-core AS ros

# no interaction for tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Updating Ubuntu packages
RUN apt-get update && yes | apt-get upgrade

# Adding utils
RUN apt-get update && \
    apt-get install -y  --no-install-recommends \
                        wget \
                        bzip2 \
                        terminator \
                        sudo \
                        x11-apps \
                        dbus-x11 \
                        dirmngr \
                        gnupg2 \
                        curl \
                        lsb-release \
                        && apt-get clean \
                        && rm -rf /var/lib/apt/lists/*

# --------- Python

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.5 \
    python3-pip \
    wget \
    && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
RUN pip3 install nibabel pydicom matplotlib pillow
RUN pip3 install med2image

# First: get all the dependencies:
#
RUN apt-get update
RUN apt-get install -y  cmake git libgtk2.0-dev pkg-config libavcodec-dev \
                        libavformat-dev libswscale-dev python-dev python-numpy libtbb2 libtbb-dev \
                        libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev unzip \
                        glew-utils libglew-dev \
                        libboost-all-dev \
                        libeigen3-dev \
                        wget \
                        libxt-dev \
                        && apt-get clean \
                        && rm -rf /var/lib/apt/lists/* 
    
# ---------- VTK
ENV VTK_VERSION="8.2.0"
ENV VTK_VER="8.2"
WORKDIR /

RUN wget -nv -O- http://www.vtk.org/files/release/${VTK_VER}/VTK-${VTK_VERSION}.tar.gz | \
    tar xz && \
    cd VTK-${VTK_VERSION} && \
    mkdir build && cd build  && \
    cmake \
    -DVTK_Group_Qt=OFF \
    -DVTK_Group_Imaging=ON \
    -DVTK_Group_Views=ON \
    -DBUILD_TESTING=OFF \
    -DVTK_USE_SYSTEM_LIBRARIES=OFF \
    -DVTK_USE_SYSTEM_LIBPROJ4=OFF \
    -DVTK_USE_SYSTEM_GL2PS=OFF \
    -DVTK_USE_SYSTEM_LIBHARU=OFF \
    -DVTK_USE_SYSTEM_PUGIXML=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    .. \
    ##
    ## Add variable to enable make to use all cores
    && export NUMPROC=$(nproc --all) \
    && make -j$NUMPROC install \
    && cd .. && rm -rf ${VTK_VERSION} && rm -rf VTK-${VTK_VERSION}.tar.gz

# ----------OpenCV
ENV OPENCV_VERSION="4.1.2"

RUN pip3 install numpy

WORKDIR /
ENV OPENCV_VERSION="4.1.2"

## Single command to reduce image size
## Build opencv
RUN wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip && \
    unzip $OPENCV_VERSION.zip && \
    rm $OPENCV_VERSION.zip

RUN wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip && \
    unzip $OPENCV_VERSION.zip && \
    rm $OPENCV_VERSION.zip

ENV PROTOBUF_C_VERSION="3.11.4"
RUN mkdir -p /protobuf-c && \
    wget -nv -O- https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_C_VERSION/protobuf-all-$PROTOBUF_C_VERSION.tar.gz | tar xz --strip 1 -C /protobuf-c && \
    cd /protobuf-c && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    ##
    ## Add variable to enable make to use all cores
    export NUMPROC=$(nproc --all) &&\
    make -j$NUMPROC install

RUN	cd /opencv-$OPENCV_VERSION && \
	mkdir cmake_binary && cd cmake_binary && \
	cmake -DBUILD_TIFF=ON \
       -DBUILD_opencv_java=OFF \
       -DBUILD_SHARED_LIBS=OFF \
       -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib-${OPENCV_VERSION}/modules/ \
       -DWITH_CUDA=ON \
       -DBUILD_opencv_dnn=ON \
       -DWITH_CUBLAS=1 \
       -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
       -DCUDA_ARCH_BIN='3.0 3.5 5.0 6.0 6.2 7.2 7.5' \
       -DCUDA_ARCH_PTX="" \
       -DCPU_DISPATCH=AVX,AVX2 \
       -DENABLE_PRECOMPILED_HEADERS=OFF \
       -DWITH_OPENGL=OFF \
       -DWITH_OPENCL=OFF \
       -DWITH_QT=OFF \
       -DWITH_IPP=ON \
       -DWITH_TBB=ON \
       -DFORCE_VTK=ON \
       -DWITH_EIGEN=ON \
       -DWITH_V4L=ON \
       -DWITH_XINE=ON \
       -DWITH_GDAL=ON \
       -DWITH_1394=OFF \
       -DWITH_FFMPEG=OFF \
       -DBUILD_PROTOBUF=ON \
       -DBUILD_TESTS=OFF \
       -DBUILD_PERF_TESTS=OFF \
       -DCMAKE_BUILD_TYPE=RELEASE \
       -DBUILD_EXAMPLES=OFF \
    	.. \
    ##
    ## Add variable to enable make to use all cores
    && export NUMPROC=$(nproc --all) \
    && make -j$NUMPROC install \
    && rm -r /opencv-$OPENCV_VERSION \
    && rm -r /opencv_contrib-$OPENCV_VERSION

#RUN 	cd / && \
#	wget https://github.com/opencv/opencv_extra/archive/$OPENCV_VERSION.zip && \
#	unzip $OPENCV_VERSION.zip \
#   cd opencv_extra && git checkout $OPENCV_VERSION 
#ENV OPENCV_TEST_DATA_PATH="/opencv_extra/"

## -------------PANGOLIN

RUN 	cd / && \
	git clone https://github.com/stevenlovegrove/Pangolin.git && \
	cd Pangolin && git checkout v0.5 && \
	mkdir build && cd build && cmake  .. \
	&& export NUMPROC=$(nproc --all) \
    && make -j$NUMPROC install \
    && cd / && rm -rf Pangolin

# ----------- ROS Utils
# make sure the package repository is up to date
RUN apt-get -y update
RUN apt-get install -y debian-keyring debian-archive-keyring

# install ROS key
RUN apt-get install -y wget
RUN wget --no-check-certificate https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | apt-key add -

# for TESTS of exposing port
RUN apt-get install -y netcat

# update ros repository
#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
#RUN sh -c 'echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/node-latest.list'
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B9316A7BC7917B12
RUN apt-get update

RUN apt-get install -y  ros-$(rosversion -d)-visualization-msgs \
                        ros-$(rosversion -d)-turtlesim \
                        ros-melodic-rviz-visual-tools

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Add user deepware with no password, add to sudo group
RUN adduser --disabled-password --gecos '' deepware
RUN adduser deepware sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER deepware
WORKDIR /home/deepware/
RUN chmod a+rwx /home/deepware/
#RUN echo `pwd`
