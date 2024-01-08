cat test.txt
#a b c d e f g
#h i j k l m n
#o p q
#r s t
#u v w x y z
cat test.txt | xargs
#a b c d e f g h i j k l m n o p q r s t u v w x y z
cat test.txt | xargs echo
#a b c d e f g h i j k l m n o p q r s t u v w x y z
cat test.txt | xargs -t echo
#echo a b c d e f g h i j k l m n o p q r s t u v w x y z
#a b c d e f g h i j k l m n o p q r s t u v w x y z
cat test.txt | xargs -n 3
#a b c
#d e f
#g h i
#j k l
#m n o
#p q r
#s t u
#v w x
#y z
cat test.txt | xargs -n 3 echo
#a b c
#d e f
#g h i
#j k l
#m n o
#p q r
#s t u
#v w x
#y z
cat test.txt | xargs -n 3 -t echo
#echo a b c
#a b c
#echo d e f
#d e f
#echo g h i
#g h i
#echo j k l
#j k l
#echo m n o
#m n o
#echo p q r
#p q r
#echo s t u
#s t u
#echo v w x
#v w x
#echo y z
#y z
echo "nameXnameXnameXname" | xargs -d X
#name name name name
#
echo "nameXnameXnameXname" | xargs -d X -t
#echo name name name 'name'$'\n'
#name name name name
#
echo "nameXnameXnameXname" | xargs -d X -n 2
#name name
#name name
#
echo "nameXnameXnameXname" | xargs -d X -n 2 -t
#echo name name
#name name
#echo name 'name'$'\n'
#name name
#
