#!/bin/sh
#----------------------------------------------------JSON crawling------------------------------------------------------------#
#Unit test OK 10/4
if [ -e "class.json" ]; #check if the course exists
then
    echo "Course table exists "
else
    echo "Course table does not exist "
    curl 'https://timetable.nctu.edu.tw/?r=main/get_cos_list' --data \
    'm_acy=107&m_sem=1&m_degree=3&m_dep_id=17&m_group=**&m_grade=**&m_class=**&m_option=**&m_crs \
    name=**&m_teaname=**&m_cos_id=**&m_cos_code=**&m_crstime=**&m_crsoutline=**&m_costype=**' >> class.json
fi

#----------------------------------------------------JSON parsing------------------------------------------------------------#
#Unit test OK 10/6
#JSON parsing, parse cos_ename, cos_time(including location after - mark)
#use this parsing function with awk and sed to output the value of certain field

json_file="class.json"
parsed_first="cos_data.txt"
parsed_second="time_data.txt"
data_base="db.txt"
time_selected="selected_time.txt"

#use the " as file delimitor to extract whole class time
cat $json_file | awk ' BEGIN { FS="[\"]" } { for( nf_cnt=0; nf_cnt<NF; nf_cnt++ ){ if( $(nf_cnt)~/cos_time/) { printf("%s", $(nf_cnt+2)) } else if( $(nf_cnt)~/cos_ename/){ print ",", $(nf_cnt+2) } } } ' > $parsed_first

#remove some unnecessary things, and remove the tab
cat $parsed_first | sed -E -i.bak 's/   //g' $parsed_first
cat $parsed_first | sed -i.bak 's/317// ; s/--//' $parsed_first

#rearrange the data
cat $parsed_first | sed -i.bak  's/\, /,/g ; s/-/,/g' $parsed_first

#extract the time from 2G5CD-EC115,3IJK-EC222 to 2G 2C 5D 3I 3J 3K
#cat $parsed_first | less
rm -f $parsed_second
cat $parsed_first | awk 'BEGIN {FS=","} {  for( nf_cnt=0; nf_cnt<=NF; nf_cnt++ ){ if(nf_cnt==NF){ printf("\n") } else if(nf_cnt && (nf_cnt % 2 == 1)){ printf("%s,",$nf_cnt) } } } ' | awk -f awk_parsetime.sh > $parsed_second

paste -d'|' $parsed_first $parsed_second > $data_base
cat $data_base | sed -i.bak 's/,,/,/g' $data_base | cat $data_base | awk 'BEGIN {FS="|"} {print "Course data: ", $1, " time: ", $2 } '
#--------------------------------------------------------generate timetable---------------------------------------------------#
#Unit test OK 10/5
#generate the selected time
for i in 1 2 3 4 5 6
do
    for j in "M" "N" "A" "B" "C" "D" "X" "E" "F" "G" "H" "I" "J" "K" "L"
    do
        echo $i$j >> $time_selected
    done
done

#generate the timetable
sel=100 #current selected course
col=0 #is collided or not

generate_list() {
    #processed with tag item

    cat $data_base | awk ' BEGIN { FS="|"; i=0 } { printf("%d-%s off ",++i , $1) } ' > "menu_db.txt"
    #display the menu dialog and remove space if use parameter
    sed -i.bak 's/ /_/g' "menu_db.txt"
    sed -i.bak 's/_off_/ off /g' "menu_db.txt"
    sed -i.bak 's/-/ /g' "menu_db.txt"
    sel=$(dialog --stdout --buildlist "Choose one" 200 200 200 "menu_db.txt")

}
check_collision() {

}

sel_name=""
sel_time=""
sel_time_parsed=""

write_db() {
    #extracted the course name from the cos_name.txt with the selected number
    #``sel_name=$(cat "cos_data.txt" | awk ' BEGIN { i=0 } { ++i; if(i==$sel){ printf("%s", $NF) } } ')
    for i in "$sel"
    do
        echo "Selected row is ","$i"

        sel_time=$(cat "time_data.txt" | awk -v sel_row="$i" ' BEGIN { i=0 } { ++i; if(i==sel_rowl){ printf("%s", $0) } } ')
        sel_time_parsed=$(echo "$sel_time" | sed ' s/,/ /g ')

        echo "sel time parsed ", "$sel_time_parsed" | less

        sel_name=$(cat "cos_data.txt" | awk -v sel_row="$i" '  BEGIN { i=0; FS="," } { ++i; if(i==sel_rowl){ printf("%s", $NF) } } ')

        echo "sel name " , "$sel_name" | less

        #change the menu_db from off to on
        sed -E -i.bak "s/off/on/$i" "menu_db.txt"

        #change the selected time from no to yes and write the class name into it
        for j in "$sel_time_parsed"
        do
            sed -E -i.bak "s/"$j",no/"$j","$sel_name"/1" "selected_time.txt"
        done

    done

}

#-----------------------------------------------work flow-------------------------------------------------------------#
for i in 1 2 3 4 5
do

    generate_list

    #if [ $sel -eq 1 ];
    #then
    #    break
    #fd
    #check_collision
    #write_db
done



