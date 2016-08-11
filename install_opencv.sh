#!/bin/bash
echo "Installing OpenCV"
sudo apt-get update
sudo apt-get -y upgrade
echo "Removing any pre-installed ffmpeg and x264"
sudo apt-get -qq remove ffmpeg x264 libx264-dev
echo "Installing Dependenices"
sudo apt-get -y install build-essential cmake pkg-config libjpeg62-dev libjasper-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev python-dev python-numpy libtbb-dev libqt4-dev x264 v4l-utils

mkdir ~/OpenCV
cp compile_opencv.sh ~/OpenCV/
cd ~/OpenCV
echo "Downloading OpenCV"
git clone https://github.com/opencv/opencv.git
echo "Downloading OpenCV's extra modules"
git clone https://github.com/opencv/opencv_contrib.git

echo "Installing OpenCV"
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON ../opencv
cmake -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules ../opencv
make -j5
sudo make install
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig

echo "Create a shortcut for compilation with OpenCV libraries:"
echo "" >>  ~/.bashrc
echo "# alias for compiling OpenCV" >>  ~/.bashrc
echo "alias gcv='~/OpenCV/compile_opencv.sh'" >>  ~/.bashrc
. ~/.bashrc
echo "You can compile your OpenCV codes using gcv command!"
