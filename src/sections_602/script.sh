#!/bin/bash

files=($(ls))
valid=(64 96 112)

for f in ${files[@]}; do
	f_one=$(echo "$f" | cut -d "-" -f1)
	f_two=$(echo "$f" | cut -d "-" -f2)
	if [[ " ${valid[@]} " =~ " $f_one " && " ${valid[@]} " =~ " $f_two " ]]; then
		cp -r $f ../sections_new/$f/
	fi
done

