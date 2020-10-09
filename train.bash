#!/usr/bin/env bash

if [ "${1}" = "" ]; then
    echo "model name not informed"
    exit
fi

data=/content/voc-person-detection/voc.data
cfg=/content/voc-person-detection/${1}.cfg
weights=${1}.conv.15

original_location=$(pwd)
cd /content/darknet
./darknet detector train $data $cfg $weights -dont_show -map -mjpeg_port 8090
cd ${original_location}
