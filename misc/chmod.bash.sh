ll
# total 16
# drwxr-xr-x  2 hadoop hadoop 4096 May 24 15:48 ./
# drwxr-xr-x 14 hadoop hadoop 4096 Aug 18  2021 ../
# -rw-rw-r--  1 hadoop hadoop   99 May  9 19:44 file
# -rw-rw-r--  1 hadoop hadoop   17 May 24 15:48 test.sh

chmod 777 test.sh
chmod 0777 test.sh
chmod u+rwx,g+rwx,o+rwx test.sh
chmod a=rwx test.sh
chmod u=rwx,g=rwx,o=rwx test.sh
# total 16
# drwxr-xr-x  2 hadoop hadoop 4096 May 24 15:48 ./
# drwxr-xr-x 14 hadoop hadoop 4096 Aug 18  2021 ../
# -rw-rw-r--  1 hadoop hadoop   99 May  9 19:44 file
# -rwxrwxrwx  1 hadoop hadoop   17 May 24 15:48 test.sh*
