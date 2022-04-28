#!/bin/bash

read -p " Enter filename: " filename
n=1
while IFS= read -r line;
do
echo "${#line}"
n=$((n+1))
done < "${filename}"
echo "Script completed!!."