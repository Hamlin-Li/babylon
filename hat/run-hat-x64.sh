#/bin/bash

WORKSPACE_ROOT=/home/hamlin/workspace/

source /rivos/rig/bin/rig_env.sh

bash ${WORKSPACE_ROOT}/tools/setup_x64_env.sh

prerequisites='
sudo apt-get install freeglut3-dev
sudo apt install intel-opencl-icd
sudo apt-get install opencl-headers

sudo apt list nvidia*
sudo apt autoremove nvidia* --purge
sudo apt install nvidia-utils-580
sudo apt install nvidia-cuda-toolkit
'

echo ""
echo "====== Mine: setup env.bash ... ======"
. ./env.bash

echo ""
echo "====== Mine: Java home: ======"
echo ${JAVA_HOME}
echo ""
echo "====== Mine: which java: ======"
which java
echo ""
echo "====== Mine: path: ======"
echo ${PATH}


 export JEXTRACT_HOME=${WORKSPACE_ROOT}/tools/jextract-22-x64
# export JEXTRACT_HOME=${WORKSPACE_ROOT}/repos/github/jextract/build/jextract
export PATH=${JEXTRACT_HOME}/bin:$PATH

echo ""
echo "====== Mine: clean ======"
$JAVA_HOME/bin/java @hat/clean

CUDA_JAVA_DEST_DIR=${WORKSPACE_ROOT}/repos/github/jdk-babylon/hat/extractions/cuda/src/main/java/cuda/
CUDA_JAVA_SRC_DIR=${WORKSPACE_ROOT}/repos/github/jextract/samples/cuda/cuda/
# mkdir -p $CUDA_JAVA_DEST_DIR
# cp -r $CUDA_JAVA_SRC_DIR/* $CUDA_JAVA_DEST_DIR

OPENCL_JAVA_DEST_DIR=${WORKSPACE_ROOT}/repos/github/jdk-babylon/hat/extractions/cuda/src/main/java/opencl/
OPENCL_JAVA_SRC_DIR=${WORKSPACE_ROOT}/repos/github/jextract/samples/opencl/opencl/
# mkdir -p $OPENCL_JAVA_DEST_DIR
# cp -r $OPENCL_JAVA_SRC_DIR/* $OPENCL_JAVA_DEST_DIR


echo ""
echo "====== Mine: build hat artifacts (hat jar + backends and examples) ... ======"
$JAVA_HOME/bin/java @hat/bld  # this is just a shortcut for below command
echo ""
echo "====== Mine: run hat/bld.java ... ======"
# $JAVA_HOME/bin/java --add-modules jdk.incubator.code --enable-preview --source 26 hat/bld.java

echo ""
echo "====== Mine: sanity check ... ======"
$JAVA_HOME/bin/java @hat/sanity

echo ""
echo "====== Mine: run hat examples ... ======"
#   --class-path build/core-1.0.jar:build/hat-backend-ffi-shared-1.0.jar:build/hat-backend-ffi-opencl-1.0.jar:build/hat-example-mandel-1.0.jar \
${JAVA_HOME}/bin/java \
   --add-modules jdk.incubator.code --enable-preview --enable-native-access=ALL-UNNAMED \
   --class-path build/hat-core-1.0.jar:build/hat-backend-ffi-shared-1.0.jar:build/hat-backend-ffi-mock-1.0.jar:build/hat-example-mandel-1.0.jar:build/hat-example-shared-1.0.jar \
   --add-exports=java.base/jdk.internal=ALL-UNNAMED \
   -Djava.library.path=build\
   mandel.Main --headless



echo ""
echo "====== Mine: run ffi-opencl mandel ... ======"
$JAVA_HOME/bin/java @hat/run ffi-opencl mandel

echo ""
echo "====== Mine: run headless ffi-opencl mandel ... ======"
$JAVA_HOME/bin/java @hat/run headless ffi-opencl mandel


echo ""
echo "====== Mine: run verbose headless ffi-cuda mandel ... ======"
$JAVA_HOME/bin/java @hat/run verbose headless ffi-cuda mandel

echo ""
echo "====== Mine: run verbose headless ffi-cuda squares ... ======"
# $JAVA_HOME/bin/java @hat/run verbose headless ffi-cuda mandel
$JAVA_HOME/bin/java @hat/run verbose headless ffi-cuda squares
