cat test.txt
#abcdefghijklmnopqrstuvwxyz
#abcdefghijklmnopqrstuvwxyz
#abcdefghijklmnopqrstuvwxyz
#abcdefghijklmnopqrstuvwxyz
#abcdefghijklmnopqrstuvwxyz

cat test.txt| rev | cut -c -5 | rev
#vwxyz
#vwxyz
#vwxyz
#vwxyz
#vwxyz
