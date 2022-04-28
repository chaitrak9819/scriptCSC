To transform decimal number into binary--

echo enter n
read n
c=$(echo "obase=2;$n" | bc)
echo binary $c

# Input a decimal to hexadecimal
[ $# -eq 0 ] && read -p "Enter a number:" num && echo "obase=16;$num" | bc
echo "obase=16;$1" | bc

echo enter n
read n
c=$(echo "obase=8;$n" | bc)
echo octal $c