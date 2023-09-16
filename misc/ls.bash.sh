alias
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#alias egrep='egrep --color=auto'
#alias fgrep='fgrep --color=auto'
#alias grep='grep --color=auto'
#alias l='ls -CF'
#alias la='ls -A'
#alias ll='ls -alF'
#alias ls='ls --color=auto'
ls
#mm  test.sh
\ls # Escape the alias and use command with this name instead
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
