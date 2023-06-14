#cat sort.txt
#aaa:10:1.1
#ccc:30:3.3
#ddd:40:4.4
#bbb:20:2.2
#eee:50:5.5
#eee:50:5.5
sort sort.txt
#aaa:10:1.1
#bbb:20:2.2
#ccc:30:3.3
#ddd:40:4.4
#eee:50:5.5
#eee:50:5.5
sort -u sort.txt
#aaa:10:1.1
#bbb:20:2.2
#ccc:30:3.3
#ddd:40:4.4
#eee:50:5.5
uniq sort.txt
#aaa:10:1.1
#ccc:30:3.3
#ddd:40:4.4
#bbb:20:2.2
#eee:50:5.5
#cat facebook.txt
#baidu 100 5000
#google 110 5000
#sohu 100 4500
#guge 50 3000
sort facebook.txt
#baidu 100 5000
#google 110 5000
#guge 50 3000
#sohu 100 4500
sort -t ' ' -k 1.2 facebook.txt
#baidu 100 5000
#sohu 100 4500
#google 110 5000
#guge 50 3000
sort -t ' ' -k 1.2,1.2 facebook.txt
#baidu 100 5000
#google 110 5000
#sohu 100 4500
#guge 50 3000
sort -t ' ' -k 1.2,1.2 -k 3n,3 facebook.txt
#baidu 100 5000
#sohu 100 4500
#google 110 5000
#guge 50 3000
sort -t ' ' -k 1.2,1.2 -k 3nr,3 facebook.txt
#baidu 100 5000
#google 110 5000
#sohu 100 4500
#guge 50 3000
sort -t ' ' -k 3n,3 facebook.txt
#guge 50 3000
#sohu 100 4500
#baidu 100 5000
#google 110 5000
