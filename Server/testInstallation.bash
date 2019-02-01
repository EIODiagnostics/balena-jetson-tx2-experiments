#!/bin/bash

main() {
    isInitsystemOn
    startServices
    testCudaInstallation

    echo "Use control-c to quit this script"
    while true; do
        sleep 60
    done
}

isInitsystemOn() {
    if [ -z ${INITSYSTEM+x} ]; then 
        echo "Error: INITSYSTEM is unset"
    elif [ "$INITSYSTEM" = "on" ]; then
        echo "SUCCESS: INITSYSTEM is on"
    else
        echo "Error: INITSYSTEM is [${INITSYSTEM}]"
    fi
}

startServices() {
    echo "Attempting to start tomcat8 and nvidia-persistenced:"
    systemctl start tomcat8
    if [[ $? -ne 0 ]]; then
        echo "ERROR: unable to start tomcat8"
    fi
    systemctl start nvidia-persistenced
    if [[ $? -ne 0 ]]; then
        echo "ERROR: unable to start nvidia-persistenced"
    fi

    echo "Getting status of services tomcat8 and nvidia-persistenced:"
    systemctl status tomcat8
    systemctl status nvidia-persistenced
}

testCudaInstallation() {
    echo "PATH = ${PATH}"
    # PATH = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/cuda/bin

    echo "/usr/local/cuda/version.txt:"
    cat /usr/local/cuda/version.txt
    # CUDA Version 9.0.252

    jetsonUtilitiesSrc="/usr/src/app/jetsonUtilities"
    if [ -d "$jetsonUtilitiesSrc" ]; then
        pushd "$jetsonUtilitiesSrc"
        ./jetsonInfo.py

        #  NVIDIA Jetson NVIDIA Jetson TX2
        #  L4T 28.2.0 [ JetPack 3.2 ]
        #  Board: t186ref
        #  Debian GNU/Linux 8 (jessie)
        #  Kernel Version: 4.4.38-l4t-r28.2+g174510d
        popd
    fi

    nvcc --version
     # nvcc: NVIDIA (R) Cuda compiler driver
     # Copyright (c) 2005-2017 NVIDIA Corporation
     # Built on Sun_Nov_19_03:16:56_CST_2017
     # Cuda compilation tools, release 9.0, V9.0.252
 
    nvcc hello-world.cu -L /usr/local/cuda/lib -lcudart -o hello-world

    /usr/src/app/hello-world
    # Hello World!
    if [[ $? -ne 0 ]]; then
        echo "ERROR: hello-world.cu exited with an error. Is nvidia-persistenced running?"
    fi


    deviceQuerySrc="/usr/local/cuda/samples/1_Utilities/deviceQuery"
    if [ -d "$deviceQuerySrc" ]; then
        pushd "$deviceQuerySrc"
        make
        ../../bin/aarch64/linux/release/deviceQuery
        if [[ $? -ne 0 ]]; then
            echo "ERROR: deviceQuery exited with an error. Is nvidia-persistenced running?"
        fi

        popd

        #     ../../bin/aarch64/linux/release/deviceQuery Starting...
        #
        #  CUDA Device Query (Runtime API) version (CUDART static linking)
        #
        # Detected 1 CUDA Capable device(s)
        #
        # Device 0: "NVIDIA Tegra X2"
        #   CUDA Driver Version / Runtime Version          9.0 / 9.0
        #   CUDA Capability Major/Minor version number:    6.2
        #   Total amount of global memory:                 7847 MBytes (8227979264 bytes)
        #   ( 2) Multiprocessors, (128) CUDA Cores/MP:     256 CUDA Cores
        #   GPU Max Clock rate:                            1301 MHz (1.30 GHz)
        #   Memory Clock rate:                             1600 Mhz
        #   Memory Bus Width:                              128-bit
        #   L2 Cache Size:                                 524288 bytes
        #   Maximum Texture Dimension Size (x,y,z)         1D=(131072), 2D=(131072, 65536), 3D=(16384, 16384, 16384)
        #   Maximum Layered 1D Texture Size, (num) layers  1D=(32768), 2048 layers
        #   Maximum Layered 2D Texture Size, (num) layers  2D=(32768, 32768), 2048 layers
        #   Total amount of constant memory:               65536 bytes
        #   Total amount of shared memory per block:       49152 bytes
        #   Total number of registers available per block: 32768
        #   Warp size:                                     32
        #   Maximum number of threads per multiprocessor:  2048
        #   Maximum number of threads per block:           1024
        #   Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
        #   Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
        #   Maximum memory pitch:                          2147483647 bytes
        #   Texture alignment:                             512 bytes
        #   Concurrent copy and kernel execution:          Yes with 1 copy engine(s)
        #   Run time limit on kernels:                     No
        #   Integrated GPU sharing Host Memory:            Yes
        #   Support host page-locked memory mapping:       Yes
        #   Alignment requirement for Surfaces:            Yes
        #   Device has ECC support:                        Disabled
        #   Device supports Unified Addressing (UVA):      Yes
        #   Supports Cooperative Kernel Launch:            Yes
        #   Supports MultiDevice Co-op Kernel Launch:      Yes
        #   Device PCI Domain ID / Bus ID / location ID:   0 / 0 / 0
        #   Compute Mode:
        #      < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >
        #
        # deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 9.0, CUDA Runtime Version = 9.0, NumDevs = 1
        # Result = PASS
    fi
}



# call the main function now that everything has been parsed
main "$@"