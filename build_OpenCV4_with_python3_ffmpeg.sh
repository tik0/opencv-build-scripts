# This script is optimized and reduced for build OpenCV 4.x for encoding

BUILD_FOLDER=/tmp
OPENCV_TAG=4.1.2
OPENCV_INSTALL_FOLDER="/opt/opencv/ffmpeg"

cd $BUILD_FOLDER
CV_BUILD_FOLDER="opencv"
test -e ${CV_BUILD_FOLDER} || git clone https://github.com/Itseez/opencv.git ${CV_BUILD_FOLDER}
cd ${CV_BUILD_FOLDER}
git checkout tags/${OPENCV_TAG}
test -e build || mkdir build; cd build

EIGEN_INCLUDE_PATH="-D EIGEN_INCLUDE_PATH=$(pkg-config --cflags-only-I eigen3 | sed "s#-I##g")"

echo "$EIGEN_INCLUDE_PATH"

CMAKE_CALL="cmake \
${EIGEN_INCLUDE_PATH} \
-D CMAKE_INSTALL_PREFIX=${OPENCV_INSTALL_FOLDER} \
-D CMAKE_IGNORE_PATH=/usr/NX/lib \
-D BUILD_SHARED_LIBS=ON \
-D WITH_IPP=OFF \
-D OPENCV_ENABLE_NONFREE=ON \
-D OPENCV_FORCE_3RDPARTY_BUILD=ON \
-D WITH_PROTOBUF=OFF \
-D CMAKE_BUILD_TYPE=RELEASE \
-D WITH_FFMPEG=ON \
-D WITH_V4L=ON \
-D WITH_EIGEN=ON \
-D WITH_GSTREAMER=OFF \
-D WITH_GSTREAMER_0_10=OFF \
-D WITH_CUDA=OFF \
-D WITH_OPENGL=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_opencv_dnn=OFF \
-D BUILD_opencv_videoio=ON \
-D BUILD_opencv_videoio_plugins=ON \
-D BUILD_opencv_video=ON \
-D BUILD_opencv_gapi=OFF \
-D BUILD_opencv_python2=OFF \
-D BUILD_opencv_python3=ON \
-D BUILD_opencv_stitching=OFF \
-D BUILD_opencv_objdetect=OFF \
-D BUILD_opencv_features2d=OFF \
-D BUILD_opencv_ml=OFF \
.."

echo "Calling cmake:\n\
${CMAKE_CALL}"
eval "${CMAKE_CALL}"

echo "You may now build with e.g.: make -j2"
