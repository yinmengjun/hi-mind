str="Hello, World!"
str1="Hello"
str2="World"

echo ${#str}
#13

echo ${str:7}
#World!
echo ${str:7:5}
#World

echo ${str/World/Earth}
#Hello, Earth!

if [[ $str == *"World"* ]]; then
    echo "World found"
else  
    echo "World not found"
fi
#World found

echo $str | tr '[:lower:]' '[:upper:]'
#HELLO, WORLD!
echo $str | tr '[:upper:]' '[:lower:]'
#hello, world!
echo $str | awk '{ print toupper($0) }'
#HELLO, WORLD!
echo $str | awk '{ print tolower($0) }'
#hello, world!
echo $str | sed 's/[a-z]/\U&/g'
#HELLO, WORLD!
echo $str | sed 's/[A-Z]/\L&/g'
#hello, world!

echo $str1$str2
#HelloWorld

if [ "$str1" = "$str2" ]; then
    echo "Strings are equal"
else  
    echo "Strings are not equal"
fi
#Strings are not equal
