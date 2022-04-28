#!/usr/bin/bash
read -p "This script randomly generates the lottery numbers for you:
1) Loto
2) Euro Million
3) Exit


Votre choix :" number
if [ $number == 1 ]
then
echo "Numbers are:"
shuf -i 1-49 -n 5
echo "Lucky numbers are:"
shuf -i1-10 -n1
elif [ $number == 2 ]
then
echo "Numbers are"
shuf -i 1-50 -n 5
echo "stars are"
shuf -i1-10 -n1
elif [ $number == 3 ]
then
echo "Exiting Game"
exit;
else
echo "Select the correct choice"
fi