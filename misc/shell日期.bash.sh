current_date=$(date +"%Y-%m-%d %H:%M:%S")
echo $current_date
#2024-01-08 21:17:18

tomorrow=$(date -d "+1 day" +"%Y-%m-%d")
echo $tomorrow
#2024-01-09

if [ $(date -d "2024-01-08" +%s) -eq $(date -d "2024-01-09" +%s) ]; then
    echo "Dates are equal"
else
    echo "Dates are not equal"
fi
#Dates are not equal

input_date="2024-01-08"
parsed_date=$(date -d "$input_date" +"%Y-%m-%d")
echo $parsed_date
#2024-01-08
