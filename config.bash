#!/usr/bin/env bash

clone_and_compile() {
    echo -e "\nClone and compiling..."
    cd /content
    git clone https://github.com/AlexeyAB/darknet.git
    cd darknet
    sed -i 's/GPU=0/GPU=1/' Makefile
    sed -i 's/CUDNN=0/CUDNN=1/' Makefile
    sed -i 's/CUDNN_HALF=0/CUDNN_HALF=1/' Makefile
    sed -i 's/OPENCV=0/OPENCV=1/' Makefile
    make

    echo -e "\nSetting up drive integration..."
    python -c "from google.colab import drive; drive.mount('/content/drive')"
    rm -rf /content/darknet/backup
    ln -s /content/drive/My\ Drive/backup /content/darknet/backup
}

download_dataset() {
    echo -e "\nReplacing dataset variables..."
    sed -i 's|train  = /home/pjreddie/data/voc/train.txt|train = VOC_data_from_2007_to_2012/train.txt|' cfg/voc.data
    sed -i 's|valid  = /home/pjreddie/data/voc/2007_test.txt|valid = VOC_data_from_2007_to_2012/2007_test.txt|' cfg/voc.data
    sed -i 's|backup = /home/pjreddie/backup/|backup = backup|' cfg/voc.data
    head -6 cfg/voc.data

    echo -e "\nCreating dataset folder..."
    mkdir VOC_data_from_2007_to_2012
    cd VOC_data_from_2007_to_2012
    pwd

    echo -e "\nDownloading datasets..."
    wget -c http://host.robots.ox.ac.uk/pascal/VOC/voc2012/VOCtrainval_11-May-2012.tar
    wget -c http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar
    wget -c http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtrainval_06-Nov-2007.tar
    ls

    echo -e "\nUnpacking dataset files..."
    tar -xf VOCtrainval_11-May-2012.tar
    tar -xf VOCtest_06-Nov-2007.tar
    tar -xf VOCtrainval_06-Nov-2007.tar
    ls
}

label_setup() {
    echo -e "\nSetting up label files..."
    cd /content/darknet/VOC_data_from_2007_to_2012/
    python /content/voc-person-detection/label_setup.py
}

download_weights() {
    cd /content/darknet
    wget -c https://pjreddie.com/media/files/yolov3-tiny.weights
    ./darknet partial cfg/yolov3-tiny.cfg yolov3-tiny.weights yolov3-tiny.conv.15 15
}

original_location=$(pwd)
cd /content
clone_and_compile
download_dataset
label_setup
download_weights
cd ${original_location}
