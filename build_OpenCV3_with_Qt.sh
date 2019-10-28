BUILD_FOLDER=/tmp
OPENCV_TAG=3.1.0
QT_PREFIX_PATH=/opt/Qt/5.5/gcc_64
OPENCV_INSTALL_FOLDER=/usr/local

# If you build on KS Pool machine, you have to set the modules to load in "KS_MODULE_ENV" variable
# KS_MODULE_ENV="module load gcc; module load eigen; module load ffmpeg"

cd $BUILD_FOLDER
CVCON_BUILD_FOLDER="opencv_contrib"
test -e "${CVCON_BUILD_FOLDER}" || git clone https://github.com/Itseez/opencv_contrib.git
cd ${CVCON_BUILD_FOLDER}
git checkout tags/${OPENCV_TAG}
OPENCV_EXTRA_MODULES_PATH=${PWD}/modules/

cd $BUILD_FOLDER
CV_BUILD_FOLDER="opencv"
test -e ${CV_BUILD_FOLDER} || git clone https://github.com/Itseez/opencv.git ${CV_BUILD_FOLDER}
cd ${CV_BUILD_FOLDER}
git checkout tags/${OPENCV_TAG}
test -e build || mkdir build; cd build

EIGEN_INCLUDE_PATH="-D EIGEN_INCLUDE_PATH=$(pkg-config --cflags-only-I eigen3 | sed "s#-I##g")"

# Handle Qt as display manager
QT_BUILD_STRING=""
test -z ${QT_PREFIX_PATH} || QT_BUILD_STRING="-D CMAKE_PREFIX_PATH=${QT_PREFIX_PATH} -D WITH_QT=ON"

echo "$EIGEN_INCLUDE_PATH"

CMAKE_CALL="cmake \
${EIGEN_INCLUDE_PATH} \
-D CMAKE_INSTALL_PREFIX=${OPENCV_INSTALL_FOLDER} \
-D BUILD_SHARED_LIBS=OFF -D WITH_IPP=OFF -D CMAKE_BUILD_TYPE=RELEASE -D WITH_FFMPEG=ON -D WITH_EIGEN=ON -D WITH_GSTREAMER=OFF -D WITH_GSTREAMER_0_10=OFF -D WITH_CUDA=OFF -D WITH_OPENGL=ON \
${QT_BUILD_STRING} \
-D OPENCV_EXTRA_MODULES_PATH=${OPENCV_EXTRA_MODULES_PATH} \
.."

echo "Calling cmake:\n\
${CMAKE_CALL}"
eval "${CMAKE_CALL}"

echo "You may now build with e.g.: make -j2"