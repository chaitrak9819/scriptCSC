#!/bin/bash
french=$(grep -c $1 /usr/share/dict/french)
if [ $french-eq 0 ]
then
echo "word not in dictionary"
else
echo "word exists"
fi