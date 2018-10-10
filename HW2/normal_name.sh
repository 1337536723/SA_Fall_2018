#!/bin/sh 
rm -f "show.txt"

#block width = 16 each

print_type=0
none="x"
point='.'
boundary="|" #1 + class name 13 + blank_short
blank_short="  "
blank_long="            " #day + 12 + blank_short
time_split="=  " #1 + 2
long_split="==============  " #12 + 2

monday="Mon"
tuesday="Tue"
wednesday="Wed"
thursday="Thu"
friday="Fri"

thistime=""
thisday=""

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
    sed -E -i.bak 's/[1-9][MNXY].*//d' "show_name_tmp.txt"
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

find_assign() {
    
    #monday

    to_put=$(cat "final_show.txt" | awk -v sel_row="1$thistime" ' BEGIN{ FS="," } { if($1~sel_row){ printf("%s,%s,%s,%s", $2, $3, $4, $5) } } ')

    name1=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($1)==13){ print $1; } else{ print"x.           " } }')
    name2=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($2)==13){ print $2; } else{ print".            " } }')
    name3=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($3)==13){ print $3; } else{ print".            " } }')
    name4=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($4)==13){ print $4; } else{ print".            " } }')
    
    #tuesday

    to_put=$(cat "final_show.txt" | awk -v sel_row="2$thistime" ' BEGIN{ FS="," } { if($1~sel_row){ printf("%s,%s,%s,%s", $2, $3, $4, $5) } } ')

    name5=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($1)==13){ print $1; } else{ print"x.           " } }')
    name6=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($2)==13){ print $2; } else{ print".            " } }')
    name7=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($3)==13){ print $3; } else{ print".            " } }')
    name8=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($4)==13){ print $4; } else{ print".            " } }')
    
    #wednesday

    to_put=$(cat "final_show.txt" | awk -v sel_row="3$thistime" ' BEGIN{ FS="," } { if($1~sel_row){ printf("%s,%s,%s,%s", $2, $3, $4, $5) } } ')

    name9=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($1)==13){ print $1; } else{ print"x.           " } }')
    name10=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($2)==13){ print $2; } else{ print".            " } }')
    name11=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($3)==13){ print $3; } else{ print".            " } }')
    name12=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($4)==13){ print $4; } else{ print".            " } }')

    #thursday

    to_put=$(cat "final_show.txt" | awk -v sel_row="4$thistime" ' BEGIN{ FS="," } { if($1~sel_row){ printf("%s,%s,%s,%s", $2, $3, $4, $5) } } ')

    name13=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($1)==13){ print $1; } else{ print"x.           " } }')
    name14=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($2)==13){ print $2; } else{ print".            " } }')
    name15=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($3)==13){ print $3; } else{ print".            " } }')
    name16=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($4)==13){ print $4; } else{ print".            " } }')

    #friday

    to_put=$(cat "final_show.txt" | awk -v sel_row="5$thistime" ' BEGIN{ FS="," } { if($1~sel_row){ printf("%s,%s,%s,%s", $2, $3, $4, $5) } } ')

    name17=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($1)==13){ print $1; } else{ print"x.           " } }')
    name18=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($2)==13){ print $2; } else{ print".            " } }')
    name19=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($3)==13){ print $3; } else{ print".            " } }')
    name20=$(echo "$to_put" | awk 'BEGIN{ FS="," }{ if(length($4)==13){ print $4; } else{ print".            " } }')
}


print_firstline() {  
    firstline=$none$blank_short$point$monday$blank_long$point$tuesday$blank_long$point$wednesday$blank_long$point$thursday$blank_long$point$friday$blank_long

    printf "$firstline\n" >> "show.txt"
}

print_class() {
    
    line1=$thistime$blank_short$boundary$name1$blank_short$boundary$name5$blank_short$boundary$name9$blank_short$boundary$name13$blank_short$boundary$name17$blank_short$boundary
    line2=$point$blank_short$boundary$name2$blank_short$boundary$name6$blank_short$boundary$name10$blank_short$boundary$name14$blank_short$boundary$name18$blank_short$boundary
    line3=$point$blank_short$boundary$name3$blank_short$boundary$name7$blank_short$boundary$name11$blank_short$boundary$name15$blank_short$boundary$name19$blank_short$boundary
    line4=$point$blank_short$boundary$name4$blank_short$boundary$name8$blank_short$boundary$name12$blank_short$boundary$name16$blank_short$boundary$name20$blank_short$boundary

    printf "$line1\n" >> "show.txt"
    printf "$line2\n" >> "show.txt"
    printf "$line3\n" >> "show.txt"
    printf "$line4\n" >> "show.txt"
}

print_splitline() {
    allsplit=$time_split$long_split$long_split$long_split$long_split$long_split$time_split
    printf "$allsplit\n" >> "show.txt"
}


gen_table
parse_name
print_firstline


# for i in  'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L';
# do
#     for j in 1 2 3 4 5;
#     do
#         thistime=""
#         #thistime=$j$i
#         echo $j$i
#         thisday=$i
#         find_assign
#         print_class $j
#         print_splitline
#     done 
# done

for i in 'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L'
do
    # echo $i
    thistime=$i
    find_assign
    print_class
    print_splitline
done