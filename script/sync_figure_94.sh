#!/bin/sh

while true;

do rsync -avrz /home/lgs/Documents/MATLAB/toolseis/ws_drumplot/figures/* giacomo@88.198.33.201:/var/www/html/lgs_drumplot/

sleep 30;
done
