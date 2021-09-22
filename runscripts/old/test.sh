#!/bin/bash
# This script is for generating based on a bunch of individual "Control Parameter" files
GENERATING=0   # set to true with -g flag
TRAINING=0     # set to true with -t flag

if [ $# -eq 0 ]
  then
    echo "usage: run_tg [-g -t] for generate and/or train"
    exit -1
fi

while getopts “::gt” opt; do
  case $opt in
    g) 
		GENERATING=1 
		;;
	t) 
		TRAINING=1  
		;;
  esac
done
echo "GENERATING = $GENERATING, TRAINING=$TRAINING"