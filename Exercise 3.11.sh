if [ $# -ne 1 ]
then
echo " Enter the number corresponding to the month"
exit
fi
refVal='^[0-9]+$'
if ! [[ $1 =~ $refVal ]]
then
echo "Enter the Number Corresponding to the month. Ex: 1 for January"
exit
fi
m=$1
Ndays=$(date -d "$m/1 + 1 month - 1 day" "+%d days")
echo $Ndays


