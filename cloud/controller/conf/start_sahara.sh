#!/bin/bash
sahara_dir=/home/naanal/sahara-venv
source $sahara_dir/bin/activate
nohup sahara-api --config-file $sahara_dir/etc/sahara.conf > /dev/null 2>&1 &
nohup sahara-engine --config-file $sahara_dir/etc/sahara.conf > /dev/null 2>&1 &
