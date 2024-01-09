cat test.txt
#No Name Mark Percent
#01 tom 69 91
#02 jack 71 87
#03 alex 68 98

cut -f 1 -d " " test.txt
#No
#01
#02
#03

cut -f 2,3 -d " " test.txt
#Name Mark
#tom 69
#jack 71
#alex 68

cut -f 2 -d " " --complement test.txt
#No Mark Percent
#01 69 91
#02 71 87
#03 68 98

cat test.txt
#abcdefghijklmnopqrstuvwxyz
#abcdefghijklmnopqrstuvwxyz
#abcdefghijklmnopqrstuvwxyz
#abcdefghijklmnopqrstuvwxyz
#abcdefghijklmnopqrstuvwxyz

cut -c 5- test.txt
#efghijklmnopqrstuvwxyz
#efghijklmnopqrstuvwxyz
#efghijklmnopqrstuvwxyz
#efghijklmnopqrstuvwxyz
#efghijklmnopqrstuvwxyz

cut -c 1-3 test.txt
#abc
#abc
#abc
#abc
#abc

cut -c -2 test.txt
#ab
#ab
#ab
#ab
#ab

cat test.txt| rev | cut -c -5 | rev
#vwxyz
#vwxyz
#vwxyz
#vwxyz
#vwxyz

