#!/bin/bash
#John Aguinaldo
#10514966

protocol() {
    grep "suspicious" $selfile > tempf.csv #Grab lines that contains the word suspicious and save it to tempf.csv folder
    grep -i $ope tempf.csv > tempfile.csv #Grab lines where the user input protocol and save it to tempfile.csv folder

    awk 'BEGIN {FS=","}
        NR>1 {
            printf "%-6s %-15s %-10s %-15s %-10s %-6s %-10s \n", $3, $4, $5, $6, $7, $8, $9
        }' < tempfile.csv > tempresult.csv

    cat tempresult.csv #Echo the result of the file to the screen
}

sourceip() {
    grep "suspicious" $selfile > tempf.csv #Grab lines that contains the word suspicious and save it to tempf.csv folder

    awk 'BEGIN {FS=","}
        NR>1 {
            if ( $4 == "EXT_SERVER" )
                {
                    printf "%-6s %-15s %-10s %-15s %-10s %-6s %-10s \n", $3, $4, $5, $6, $7, $8, $9
                }
        }' < tempf.csv > tempresult.csv

    cat tempresult.csv #Echo the result of the file to the screen
}

destip() {
    grep "suspicious" $selfile > tempf.csv #Grab lines that contains the word suspicious and save it to tempf.csv folder

    awk 'BEGIN {FS=","}
        NR>1 {
            if ( $6 == "EXT_SERVER" )
                {
                    printf "%-6s %-15s %-10s %-15s %-10s %-6s %-10s \n", $3, $4, $5, $6, $7, $8, $9
                }
        }' < tempf.csv > tempresult.csv 

    cat tempresult.csv #Echo the result of the file to the screen
}

packet() {
    grep "suspicious" $selfile > tempf.csv #Grab lines that contains the word suspicious and save it to tempf.csv folder

    awk 'BEGIN {FS=","; ttlpackets=0}
        NR>1 {
            if ( $8 '"$operator"' '"$num"' )
                {
                    ttlpackets=ttlpackets+$8
                    printf "%-6s %-15s %-10s %-15s %-10s %-6s %-10s \n", $3, $4, $5, $6, $7, $8, $9
                }
        }
        END {print "Total packets for all matching row is ", ttlpackets }
        ' < tempf.csv > tempresult.csv

    cat tempresult.csv #Echo the result of the file to the screen
}

byte() {
    grep "suspicious" $selfile > tempf.csv #Grab lines that contains the word suspicious and save it to tempf.csv folder

    awk 'BEGIN {FS=","; ttlbytes=0}
        NR>1 {
            if ( $9 '"$operator"' '"$num"' )
                {
                    ttlbytes=ttlbytes+$9
                    printf "%-6s %-15s %-10s %-15s %-10s %-6s %-10s \n", $3, $4, $5, $6, $7, $8, $9
                }
            
        }
        END {print "Total bytes for all matching row is ", ttlbytes }
        ' < tempf.csv > tempresult.csv

    cat tempresult.csv #Echo the result of the file to the screen
} 

multi() {
    grep "suspicious" $selfile > tempf.csv #Grab lines that contains the word suspicious and save it to tempf.csv folder
    grep -i $ope tempf.csv > tempfile.csv #Grab lines where the user input protocol and save it to tempfile.csv folder

    awk 'BEGIN {FS=","; ttlpackets=0}
        NR>1 {
            if ( $4 == "EXT_SERVER" && $8 '"$compare"' '"$numb"' )
                {
                    ttlpackets=ttlpackets+$8
                    printf "%-6s %-15s %-10s %-15s %-10s %-6s %-10s \n", $3, $4, $5, $6, $7, $8, $9
                }
        }
        END {print "Total packets for all matching row is ", ttlpackets }
        ' < tempfile.csv > tempresult.csv


    cat tempresult.csv #Echo the result of the file to the screen
}

all() {
    i=0

    while [[ $i -lt $count ]]
}


declare -a logs #Create an array called logs
pattern="serv_acc_log.+csv$" #Pattern to look for
menucntr=0 #Counter set to 0

for file in ./*; #Check the file inside of this location
do
    if [[ $file =~ $pattern ]]; #Check if the files has a same pattern eg. serv_acc_log_03042020.csv
        then
        logs+=($(basename $file)) #Strips the directory and suffixes from file names eg. echo the file name without any leading directory components removed
        
    fi
done

count=${#logs[*]} #Counts the total amount of files inside the array

echo -e "This folder contains $count server logs. \n"

for file in "${logs[@]}"; #For every file inside the array run this
do
    echo -e "$menucntr) $file" #Echo the number of counter and the file name eg. 1) serv_acc_log_03042020.csv
    let menucntr++ #increment the counter
done

echo -e "$menucntr) Exit out of the program"
echo -e "\t" #Creates a blank space
int='^[0-9]+$' #Variable that specify what is only accept (only numbers)

while true;
    do
        read -p "Enter the number of file in the menu above you wish to search: " sel

    if [[ $sel =~ $int ]] && [[ $sel -lt $menucntr ]]; #If the user entered an integer and is less than the menucounter store the selected file into the variable selfile
        then
            echo -e "You have selected ${logs[sel]} \n"
            selfile=${logs[$sel]}
            break

    elif [[ $sel =~ $int ]] && [[ $sel -eq $menucntr ]]; #If the user eneted an integer and is eqial to the menucounter exit out of the program
        then
            echo -e "Exiting out of the program..."
            exit 1 #Exit out of the program safely

    else #If the user enetered neither of the statement above prompt the user that s/he entered is invalid and try again 
        echo -e "Invalid number of file in the menu above. Please try again. \n"

    fi

done

echo -e "1)Protocol\n2)Source IP\n3)Destination IP\n4)Packets\n5)Bytes\n6)To view more than one Criteria\n7)Exit out of the Program\n"

while true;
    do
        read -p "In the menu above enter the name of the criteria you wish to view: " criteria
    if [ $criteria == "1" ]; #Protocol #If user entered 1 run this command
        then
            while true;
                do
                    read -p "Enter the protocol you wish to view (TCP, UDP, ICMP, GRE): " ope
                    ope=${ope^^} #Make user input uppercase
                if [[ $ope == "TCP" ]] || [[ $ope == "UDP" ]] || [[ $ope == "ICMP" ]] || [[ $ope == "GRE" ]]; #If the the user input is either TCP, UDP, ICMP or GRE run this command
                    then
                        protocol $selfile $ope #Call the function with the user selected file to view and the type of protocol s/he wants to view 
                        break
                else #If what the user has eneted is not a protocol prompt the user that what s/he eneted is an invalid protol
                    echo -e "Invalid Protocol! Enter either TCP, UDP, ICMP or GRE"
                
                fi
            done
        break

    elif [ $criteria == "2" ]; #Source IP #If user entered 2 run this command
        then
            while true;
                do
                    read -p "Enter Source IP: " source
                    source=${source^^} #Make user input uppercase
                    substring="EXT" #Substring
                if [[ $source == *"$substring"* ]] || [[ $source == $int ]]; #If the user entered contains the substring of EXT
                    then
                        sourceip $selfile $ext #Call the function with the user selected file to view and the EXT_SERVER
                        break
                else
                    echo -e "Not a valid input."

                fi
            done
        break

        elif [ $criteria == "3" ]; #Destination IP #If user entered 3 run this command
        then
            while true;
                do
                    read -p "Enter Source IP: " destination
                    destination=${source^^} #Make user input uppercase
                    ext="EXT_SERVER"
                    substring="EXT" #Substring
                if [[ $destinayion == *"$substring"* ]]; #If the user entered contains the substring of EXT
                    then
                        destip $selfile $ext #Call the function with the user selected file to view and the EXT_SERVER
                        break
                else
                    echo -e "Not a valid input."

                fi
            done
        break

    elif [ $criteria == "4" ]; #Packets #If user entered 4 run this command
        then
            while true;
                do
                    read -p "Specify the number you wish to search for: " num #Prompt the user to enter a number s/he wants to view or vice versa

                if [[ $num =~ $int ]]; #Check if the user input is an integer
                    then
                        while true;
                            do
                                echo -e "\nHow do you want to compare the $num with\n1)Greater than (<)\n2)Less than (>)\n3)Equal to (==)\n4)Does not equal to (!=)"
                                read -p "Enter the operator in the menu above: " operator #Prompt the user s/he want to compare the number to eg. find number less than (>) 10
                                operator=${operator,,} #Make user input lowercase
                            if [[ $operator == '>' ]] || [[ $operator == '<' ]] || [[ $operator == '==' ]] || [[ $operator == '!=' ]];
                                then
                                    packet $selfile $operator $num #Call the function with the user selected file to view along with the operator and the integer
                                    break
                            else #If user input is not an available operator prompt the user that is not a valid operator
                                echo "not a valid operator. Please try again."
                            fi
                        done
                    break

                else #If user input is not an integer prompt the user that it is not an integer
                    echo "Error! Please enter an Integer"

                fi
            done            
        break            

    elif [ $criteria == "5" ]; #Bytes #If user entered 5 run this command
        then
            while true;
                do
                    read -p "Specify the number you wish to search for: " num #Prompt the user to enter a number s/he wants to view or vice versa

                if [[ $num =~ $int ]]; #Check if the user input is an integer
                    then
                        while true;
                            do
                                echo -e "\nHow do you want to compare the $num with\n1)Greater than (<)\n2)Less than (>)\n3)Equal to (==)\n4)Does not equal to (!=)"
                                read -p "Enter the operator in the menu above: " operator #Prompt the user s/he want to compare the number to eg. find number less than (>) 10
                                operator=${operator,,} #Make user input lowercase
                            if [[ $operator == '>' ]] || [[ $operator == '<' ]] || [[ $operator == '==' ]] || [[ $operator == '!=' ]];
                                then
                                    byte $selfile $operator $num #Call the function with the user selected file to view along with the operator and the integer
                                    break
                            else #If user input is not an available operator prompt the user that is not a valid operator
                                echo "not a valid operator. Please try again."
                            fi
                        done
                    break

                else #If user input is not an integer prompt the user that it is not an integer
                    echo "Error! Please enter an Integer"

                fi
            done            
        break           

    elif [ $criteria == "6" ];
        then
            while true;
            do
                read -p "Enter the protocol you wish to view (TCP, UDP, ICMP, GRE): " ope #Prompt the user to enter specified protocol
                ope=${ope^^} #Make user input uppercase
                if [[ $ope == "TCP" ]] || [[ $ope == "UDP" ]] || [[ $ope == "ICMP" ]] || [[ $ope == "GRE" ]]; #If the the user input is either TCP, UDP, ICMP or GRE run this command
                    then
                        oper=$ope #Save the protocol into the oper variable
                        break
                else #If what the user has eneted is not a protocol prompt the user that what s/he eneted is an invalid protol
                    echo -e "Invalid Protocol! Enter either TCP, UDP, ICMP or GRE"
                fi
            done

            while true;
            do
                read -p "Enter Source IP: " source #Prompt user to enter a Source IP
                source=${source^^} #Make user input uppercase
                ext="EXT_SERVER"
                substring="EXT" #Substring
                if [[ $source == *"$substring"* ]]; #If the user entered contains the substring of EXT
                    then
                        sourceip=$ext
                        break
                else
                    echo -e "Not a valid source Try entering EXT_SERVER."
                fi
            done

            while true;
            do
                read -p "Specify the number of packet you wish to view: " num #Prompt the user to enter a number s/he wants to view or vice versa
                if [[ $num =~ $int ]]; #Check if the user input is an integer
                    then
                        numb=$num
                        echo -e "\nHow do you want to compare the $num with\n1)Greater than (<)\n2)Less than (>)\n3)Equal to (==)\n4)Does not equal to (!=)"
                        while true;
                            do
                                read -p "Enter the operator in the menu above: " operator #Prompt the user s/he want to compare the number to eg. find number less than (>) 10
                                operator=${operator,,} #Make user input lowercase
                            if [[ $operator == '>' ]] || [[ $operator == '<' ]] || [[ $operator == '==' ]] || [[ $operator == '!=' ]];
                                then
                                    compare=$operator  #Call the function with the user selected file to view along with the operator and the integer
                                    break
                            else #If user input is not an available operator prompt the user that is not a valid operator
                                echo "not a valid operator. Please try again."
                            fi
                        done
                else #If user input is not an integer prompt the user that it is not an integer
                    echo "Error! Please enter an Integer"
                fi
            break
            done

        multi $oper $sourceip $numb $compare 
        break


    elif [ $criteria == "7" ]; #If user entered 7 exit out of the program
        then
            echo -e "Exiting out of the program..."
            exit 1

    else #If the user enetered any other options that is not specified above promt the user that criteria does not exit
        echo 'Criteria does not exist. Please try again.'
    fi

done

echo -e "\t" #Create a blank space

while true;
    do
        read -p 'Please enter a filename you wish to save this content. Enter q to cancel: ' filename #Prompt user to input a file name to save the content into

    if [[ -f $filename ]]; #Check if user filename already exist in the locvation
        then echo "A file name of $filename already exist in the folder. Please try again."

    elif [ $filename == "q" ]; #if user entered q exit out of the program
        then
            echo -e "Exiting out of the program..."
            exit 1

    else
        cp tempresult.csv "$filename.csv" #Copy the content of the file into the user specified filename
        echo -e "The result is now saved in $filename.csv file"
        break

    fi

done

exit 0