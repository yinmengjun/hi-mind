myfunc() {
    local myresult='some value'
    echo $myresult
}

result="$(myfunc)"

echo $result
# some value
