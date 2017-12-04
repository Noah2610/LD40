#!/bin/bash

files=($(ls))
valid=(64 80 96 112)

for f in ${files[@]}; do
	f_one=$(echo "$f" | cut -d "-" -f1)
	f_two=$(echo "$f" | cut -d "-" -f2)
	if [[ " ${valid[@]} " =~ " $f_one " && " ${valid[@]} " =~ " $f_two " && "$f_one" -le "$f_two" ]]; then
		cp -r $f ../sections_16/$f/
	fi
done

