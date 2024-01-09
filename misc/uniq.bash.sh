#cat uniq.txt
#aaa:10:1.1
#ccc:30:3.3
#ddd:40:4.4
#eee:50:5.5
#bbb:20:2.2
#eee:50:5.5

uniq uniq.txt
#aaa:10:1.1
#ccc:30:3.3
#ddd:40:4.4
#eee:50:5.5
#bbb:20:2.2
#eee:50:5.5

uniq -u uniq.txt
#aaa:10:1.1
#ccc:30:3.3
#ddd:40:4.4
#eee:50:5.5
#bbb:20:2.2
#eee:50:5.5

sort uniq.txt
#aaa:10:1.1
#bbb:20:2.2
#ccc:30:3.3
#ddd:40:4.4
#eee:50:5.5
#eee:50:5.5

sort -u uniq.txt
#aaa:10:1.1
#bbb:20:2.2
#ccc:30:3.3
#ddd:40:4.4
#eee:50:5.5

sort uniq.txt | uniq
#aaa:10:1.1
#bbb:20:2.2
#ccc:30:3.3
#ddd:40:4.4
#eee:50:5.5

sort uniq.txt | uniq -u
#aaa:10:1.1
#bbb:20:2.2
#ccc:30:3.3
#ddd:40:4.4

sort uniq.txt | uniq -c
#      1 aaa:10:1.1
#      1 bbb:20:2.2
#      1 ccc:30:3.3
#      1 ddd:40:4.4
#      2 eee:50:5.5

sort uniq.txt | uniq -d
#eee:50:5.5
