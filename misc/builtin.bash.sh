echo "the Great Wall"
#the Great Wall
type -t echo
#builtin

echo() {
    printf "123\n"
}

echo
#123
type -t echo
#function

builtin echo -e "backslash \\"
#backslash \
