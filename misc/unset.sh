Fruits=('Apple' 'Banana' 'Orange')
unset Fruits[2]
echo ${Fruits[@]}
# Apple Banana
