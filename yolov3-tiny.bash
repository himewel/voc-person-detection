#!/usr/bin/env bash

model_config() {
    echo -e "\nUpdating model configs..."
    sed -i -e 's/.*anchors .*/anchors = 16, 39,  34, 87,  49,185,  84,125,  89,255, 170,194, 136,316, 215,339, 346,363/' cfg/yolov3-tiny.cfg
    sed -i 's|classes=80|classes=1|' cfg/yolov3-tiny.cfg
    sed -i 's|filters=255|filters=18|' cfg/yolov3-tiny.cfg

    sed -i 's|batch=1|batch=64|' cfg/yolov3-tiny.cfg
    sed -i 's|subdivisions=1|subdivisions=64|' cfg/yolov3-tiny.cfg
    sed -i 's|max_batches = 500200|max_batches = 50200|' cfg/yolov3-tiny.cfg
    sed -i 's|steps=400000,450000|steps=40000,45000|' cfg/yolov3-tiny.cfg

    head -20 cfg/yolov3-tiny.cfg
}

download_weights() {
    echo -e "\nDownloading pre trained weights..."
    wget -c https://pjreddie.com/media/files/yolov3-tiny.weights

    echo -e "\nStructuring weights file..."
    ./darknet partial cfg/yolov3-tiny.cfg yolov3-tiny.weights yolov3-tiny.conv.15 15
}

model_config
download_weights
