echo "Enter the first number" 
read a

echo "Enter the second number" 
read b

echo "Enter the operator:"
echo -e "Addition: +\nSubtraction: -\nMultiplication: x\nDivision: /\nModulus: %\nPower: **"
read op

	case $op in
	 +) c=`expr $a + $b`
		echo "Sum of $a and $b is $c";;
		
	 -) c=`expr $a - $b`
            echo "Difference of $a and $b is $c";;
            
	 x) c=`expr $a \* $b`
            echo "Product of $a and $b is $c";;
            
	 /) c=`expr $a / $b`
            echo "Division of $a and $b is $c";;

	 %) c=`expr $a % $b`
            echo "Modulus of $a and $b is $c";;
	 
	 **) c=`expr $a ** $b`
            echo "Power of $a and $b is $c";;
            
	 *) echo "Invalid Operator"
	    exit;;
	esac