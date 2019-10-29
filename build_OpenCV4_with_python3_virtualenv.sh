# This script is optimized and reduced for build OpenCV 4.x for image stitching
# Using an virtual environment ${VIRTUAL_ENV_PREFIX} and custom ${OPENCV_INSTALL_FOLDER}
# Hints regarding virtual-env from https://www.pyimagesearch.com/2016/10/24/ubuntu-16-04-how-to-install-opencv/

BUILD_FOLDER=/tmp
OPENCV_TAG=4.1.2
OPENCV_INSTALL_FOLDER="/opt/usr/local"
VIRTUAL_ENV_PREFIX="cv"

if [[ $VIRTUAL_ENV_PREFIX != "" ]]; then
	export WORKON_HOME=$HOME/.virtualenvs
	source /usr/local/bin/virtualenvwrapper.sh
	mkvirtualenv ${VIRTUAL_ENV_PREFIX} -p python3
	workon ${VIRTUAL_ENV_PREFIX}
	python3 -m pip install numpy
fi

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
-D WITH_FFMPEG=OFF \
-D WITH_V4L=OFF \
-D WITH_EIGEN=ON \
-D WITH_GSTREAMER=OFF \
-D WITH_GSTREAMER_0_10=OFF \
-D WITH_CUDA=OFF \
-D WITH_OPENGL=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_opencv_dnn=OFF \
-D BUILD_opencv_videoio=OFF \
-D BUILD_opencv_videoio_plugins=OFF \
-D BUILD_opencv_video=OFF \
-D BUILD_opencv_gapi=OFF \
-D OPENCV_EXTRA_MODULES_PATH=${OPENCV_EXTRA_MODULES_PATH} \
-D PYTHON_EXECUTABLE=~/.virtualenvs/${VIRTUAL_ENV_PREFIX}/bin/python \
-D BUILD_opencv_aruco=OFF \
-D BUILD_opencv_bgsegm=OFF \
-D BUILD_opencv_bioinspired=OFF \
-D BUILD_opencv_ccalib=OFF \
-D BUILD_opencv_cnn_3dobj=OFF \
-D BUILD_opencv_cudaarithm=OFF \
-D BUILD_opencv_cudabgsegm=OFF \
-D BUILD_opencv_cudacodec=OFF \
-D BUILD_opencv_cudafeatures2d=OFF \
-D BUILD_opencv_cudafilters=OFF \
-D BUILD_opencv_cudaimgproc=OFF \
-D BUILD_opencv_cudalegacy=OFF \
-D BUILD_opencv_cudaobjdetect=OFF \
-D BUILD_opencv_cudaoptflow=OFF \
-D BUILD_opencv_cudastereo=OFF \
-D BUILD_opencv_cudawarping=OFF \
-D BUILD_opencv_cudev=OFF \
-D BUILD_opencv_cvv=OFF \
-D BUILD_opencv_datasets=OFF \
-D BUILD_opencv_dnn_objdetect=OFF \
-D BUILD_opencv_dnns_easily_fooled=OFF \
-D BUILD_opencv_dnn_superres=OFF \
-D BUILD_opencv_dpm=OFF \
-D BUILD_opencv_face=OFF \
-D BUILD_opencv_freetype=OFF \
-D BUILD_opencv_fuzzy=OFF \
-D BUILD_opencv_hdf=OFF \
-D BUILD_opencv_hfs=OFF \
-D BUILD_opencv_img_hash=OFF \
-D BUILD_opencv_line_descriptor=OFF \
-D BUILD_opencv_matlab=OFF \
-D BUILD_opencv_optflow=OFF \
-D BUILD_opencv_ovis=OFF \
-D BUILD_opencv_phase_unwrapping=OFF \
-D BUILD_opencv_plot=OFF \
-D BUILD_opencv_quality=OFF \
-D BUILD_opencv_reg=OFF \
-D BUILD_opencv_rgbd=OFF \
-D BUILD_opencv_saliency=OFF \
-D BUILD_opencv_sfm=OFF \
-D BUILD_opencv_shape=OFF \
-D BUILD_opencv_stereo=OFF \
-D BUILD_opencv_structured_light=OFF \
-D BUILD_opencv_superres=OFF \
-D BUILD_opencv_surface_matching=OFF \
-D BUILD_opencv_text=OFF \
-D BUILD_opencv_tracking=OFF \
-D BUILD_opencv_videostab=OFF \
-D BUILD_opencv_viz=OFF \
-D BUILD_opencv_ximgproc=OFF \
-D BUILD_opencv_xobjdetect=OFF \
-D BUILD_opencv_xphoto=OFF \
.."

echo "Calling cmake:\n\
${CMAKE_CALL}"
eval "${CMAKE_CALL}"

echo "You may now build with e.g.: workon ${VIRTUAL_ENV_PREFIX}; make -j2"
