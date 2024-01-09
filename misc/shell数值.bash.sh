let a=5+5
echo $a
#10

let a++
echo $a
#11
echo $((--a))
#10
echo $((a--))
#10
echo $a
#9

a=$((6 + 6))
echo $a
#12

echo $((10 % 3))
#1

echo $((5 & 3))
#1

a=`expr 5 + 5`
echo $a
#10

echo "scale=2; 5/3" | bc
#1.66

a=5.5
b=6.6
if (( $(echo "$a < $b" | bc -l) )); then
    echo "a is less than b";
fi
#a is less than b

echo | awk '{print sin(1)}'
#0.841471

if [ 5 -eq 5 ]; then
    echo "Equal";
fi
#Equal

echo $RANDOM
#30459

printf "%.2f\n" 123.456
#123.46
