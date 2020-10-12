#!/usr/bin/env bash

if [ "${1}" = "" ]; then
    echo "model name not informed"
    exit
fi

data=/content/voc-person-detection/voc.data
cfg=/content/voc-person-detection/${1}.cfg

if [ "${2}" = "" ]; then
    weights=/content/darknet/yolov3-tiny.conv.15
else
    weights=/content/darknet/${2}.conv.15
fi

original_location=$(pwd)
cd /content/darknet
./darknet detector train $data $cfg $weights -dont_show -map -mjpeg_port 8090 > /content/darknet/backup/${1}.log
cp /content/darknet/chart.png /content/darknet/backup/chart_${1}.png
cd ${original_location}
