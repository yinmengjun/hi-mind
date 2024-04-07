# break的可选参数n缺省值为1。
for ((i = 3; i > 0; i--)); do
    for ((j = 3; j > 0; j--)); do
        if ((j == 2)); then
            # 换成break 1时结果一样
            break
        fi

        printf "%s %s\n" "${i}" "${j}"
    done
done
#3 3
#2 3
#1 3

for ((i = 3; i > 0; i--)); do
    for ((j = 3; j > 0; j--)); do
        if ((j == 2)); then
            break 2
        fi

        printf "%s %s\n" "${i}" "${j}"
    done
done
#3 3
