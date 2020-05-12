#!/bin/bash
oldext="c.cpp"
newext="cpp"

dir=$(eval pwd)
for file in $(ls $dir | grep .$oldext)
    do
    name=$(ls $file | cut -d. -f1)
    mv $file ${name}.$newext
    done
echo "chang done!"
