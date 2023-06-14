ls
#mm  test.sh
ls --color=auto
ls -al
#total 16
#drwxr-xr-x  2 hadoop hadoop 4096 Apr 22 21:22 .
#drwxr-xr-x 15 hadoop hadoop 4096 Apr 23 02:15 ..
#-rw-rw-r--  1 hadoop hadoop   28 Apr 23 01:44 mm
#-rwxrwxr-x  1 hadoop hadoop   98 Apr 23 02:19 test.sh
ls -alF
#total 16
#drwxr-xr-x  2 hadoop hadoop 4096 Apr 22 21:22 ./
#drwxr-xr-x 15 hadoop hadoop 4096 Apr 23 02:15 ../
#-rw-rw-r--  1 hadoop hadoop   28 Apr 23 01:44 mm
#-rwxrwxr-x  1 hadoop hadoop   98 Apr 23 02:19 test.sh*
ls -lt
#total 8
#-rwxrwxr-x 1 hadoop hadoop 98 Apr 23 02:19 test.sh
#-rw-rw-r-- 1 hadoop hadoop 28 Apr 23 01:44 mm
ls -ltr
#total 8
#-rw-rw-r-- 1 hadoop hadoop 28 Apr 23 01:44 mm
#-rwxrwxr-x 1 hadoop hadoop 98 Apr 23 02:19 test.sh
ls -ltr /home/hadoop/Desktop
#total 8
#-rw-rw-r-- 1 hadoop hadoop 28 Apr 23 01:44 mm
#-rwxrwxr-x 1 hadoop hadoop 98 Apr 23 02:19 test.sh
