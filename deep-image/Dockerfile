# This is an auto generated Dockerfile for ros:ros-core
# generated from docker_images/create_ros_core_image.Dockerfile.em
FROM nvidia/cuda

# RUN executes a shell command
# You can chain multiple commands together with && 
# A \ is used to split long lines to help with readability
# This particular instruction installs the source files 
# for deviceQuery by installing the CUDA samples via apt
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-samples-$CUDA_PKG_VERSION && \
    rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    curl \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*


# Setup sources.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# setup keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# no interaction for tzdata
ARG DEBIAN_FRONTEND=noninteractive

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y \
    ros-melodic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
#COPY ./ros_entrypoint.sh /

#ENTRYPOINT ["/ros_entrypoint.sh"]
#CMD ["bash"]

RUN apt-get install python-rosinstall \
			python-wstool build-essential \
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
RUN apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev \
libavformat-dev libswscale-dev python-dev python-numpy libtbb2 libtbb-dev \
libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev unzip \
glew-utils libglew-dev \
libboost-all-dev \
libeigen3-dev \
wget


# ---------- VTK
ENV VTK_VERSION="8.2.0"
ENV VTK_VER="8.2"

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
    .. && \
    make -j $NJOBS && \
    make install && \
    cd .. && rm -rf ${VTK_VERSION}

# ----------OpenCV
ENV OPENCV_VERSION="4.1.2"

RUN pip3 install numpy

# Just get a simple editor for convienience (you could just cancel this line)
RUN apt-get install -y vim

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
       -DCUDA_ARCH_BIN='3.0 3.5 5.0 6.0 6.2' \
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
       -DBUILD_EXAMPLES=ON \
    	.. \
    ##
    ## Add variable to enable make to use all cores
    && export NUMPROC=$(nproc --all) \
    && make -j$NUMPROC install

#RUN rm -r /opencv-$OPENCV_VERSION && \
#    rm -r /opencv_contrib-$OPENCV_VERSION

RUN 	cd / && \
	wget https://github.com/opencv/opencv_extra/archive/$OPENCV_VERSION.zip && \
	unzip $OPENCV_VERSION.zip
	##cd opencv_extra && git checkout $OPENCV_VERSION 

ENV OPENCV_TEST_DATA_PATH="/opencv_extra/"

## -------------PANGOLIN


RUN 	cd / && \
	git clone https://github.com/stevenlovegrove/Pangolin.git && \
	cd Pangolin && git checkout v0.5 && \
	mkdir build && cd build && cmake  .. \
	&& make -j4 && make install

RUN apt-get install -qqy x11-apps libcanberra-gtk-module libcanberra-gtk3-module


