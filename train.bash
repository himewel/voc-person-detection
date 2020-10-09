#!/usr/bin/env bash

if [ "${1}" = "" ]; then
    echo "model name not informed"
    exit
fi

pip install pyngrok
python -c "from pyngrok import ngrok; print(ngrok.connect(port = '8090'))"
./darknet detector train cfg/voc.data cfg/${1}.cfg ${1}.conv.15 -dont_show -map -mjpeg_port 8090
