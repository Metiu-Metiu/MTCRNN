#!/bin/bash

while true; do
    read -p 'Proceed to remove logs and output files [Yn]? ' yn
    case $yn in
        [Yy]* ) echo "cleaning"; rm logs/*; rm -r output/*;  break;;
        [Nn]* ) echo "not cleaning"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
