#!/bin/sh 
rm -f "show1.txt"

none="x"
point="."
boundary="|"
blank_short="               "
blank_long="                  "
time_split="= "
long_split="=================== "

monday="Mon"
tuesday="Tue"
wednesday="Wed"
thursday="Thu"
friday="Fri"

name1=""
name2=""
name3=""
name4=""

#Use sed to make 13 character a line and next line, split with, 
gen_table() {
    rm -f "empty_time.txt"
    touch "empty_time.txt"
    for i in 1 2 3 4 5 
    do
        for j in  "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L"
        do
            echo $i$j >> "empty_time.txt"
        done
    done
}

parse_name() {
    cp "selected_time.txt" "show_name_tmp.txt"
    #remove the time to merge later
    sed -E -i.bak 's/[1-9][A-Z],//g' "show_name_tmp.txt"
    #split the string every 13 character long
    sed -E -i.bak 's/(.{13})/\1\,/g' "show_name_tmp.txt"

    # rm -f "show_name_processed.txt"
    # touch "show_name_processed.txt"
    #padding the white space
    cat "show_name_tmp.txt" | awk -f splitfill.sh > "show_name_processed.txt"
    #printf("debug: %s i=[%d] NF=[%d]\n", $nf_cnt, i, NF) }
    paste -d',' "empty_time.txt" "show_name_processed.txt" > "final_show.txt"
    
}   

# find_assign() {

# }


print_firstline() {  
    firstline=$none$blank_short$monday$boundary$blank_short$tuesday$boundary$blank_short$wednesday$boundary$blank_short$thursday$boundary$blank_short$friday$boundary
    printf "$firstline\n" >> "show1.txt"
}

print_class() {
    line1=$1$blank_long$boundary$blank_long$boundary$blank_long$boundary$blank_long$boundary$blank_long$boundary
    line2=$1$blank_long$boundary$blank_long$boundary$blank_long$boundary$blank_long$boundary$blank_long$boundary
    line3=$1$blank_long$boundary$blank_long$boundary$blank_long$boundary$blank_long$boundary$blank_long$boundary
    line4=$1$blank_long$boundary$blank_long$boundary$blank_long$boundary$blank_long$boundary$blank_long$boundary
    printf "$line1\n" >> "show1.txt"
    printf "$line2\n" >> "show1.txt"
    printf "$line3\n" >> "show1.txt"
    printf "$line4\n" >> "show1.txt"
}

print_splitline() {
    allsplit=$time_split$long_split$long_split$long_split$long_split$long_split$time_split
    printf "$allsplit\n" >> "show1.txt"
}

gen_table
parse_name
