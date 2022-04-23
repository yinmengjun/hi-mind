cat *.sql
lines=(`cat "mm"`)
# cat "mm"
# line11,line12
# line21,line22
echo ${lines[@]}
# line11,line12 line21,line22
