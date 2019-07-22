#!/bin/bash
echo "Installing OpenCV"
sudo apt-get update
sudo apt-get -y upgrade

echo "Removing any pre-installed x264"
sudo apt -y remove x264 libx264-dev

echo "Installing the compiler"
sudo apt-get -y install build-essential

echo "Installing required dependenices"
sudo apt -y install checkinstall cmake pkg-config yasm
sudo apt -y install git gfortran
sudo apt -y install libjpeg8-dev libpng-dev
sudo apt -y install libtiff5-dev
sudo apt -y install libtiff-dev
sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
sudo apt -y install libxine2-dev libv4l-dev

cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h

sudo apt -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt -y install libgtk2.0-dev libtbb-dev qt5-default
sudo apt -y install libatlas-base-dev
sudo apt -y install libfaac-dev libmp3lame-dev libtheora-dev
sudo apt -y install libvorbis-dev libxvidcore-dev
sudo apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt -y install libavresample-dev
sudo apt -y install x264 v4l-utils
 
echo "Installing optional dependenices"
sudo apt -y install libprotobuf-dev protobuf-compiler
sudo apt -y install libgoogle-glog-dev libgflags-dev libqt4-dev
sudo apt -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

echo "Installing python libraries"
sudo apt -y install python3-dev python3-pip
sudo -H pip3 install -U pip numpy
sudo apt -y install python3-testresources

mkdir ~/opencv
cp compile_opencv.sh ~/opencv/
cd ~/opencv
echo "Downloading OpenCV"
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout 4.1.0
cd ..
echo "Downloading OpenCV's extra modules"
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout 4.1.0
cd ..

echo "Installing OpenCV"
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D WITH_TBB=ON \
        -D WITH_V4L=ON \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON \
        ../opencv
make -j4
sudo make install
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig

echo "Create a shortcut for compilation with OpenCV libraries:"
echo "" >>  ~/.bashrc
echo "# alias for compiling OpenCV" >>  ~/.bashrc
echo "alias gcv='~/OpenCV/compile_opencv.sh'" >>  ~/.bashrc
. ~/.bashrc
echo "You can compile your OpenCV codes using gcv command!"
