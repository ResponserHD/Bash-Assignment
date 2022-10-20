#!/bin/bash
#John Aguinaldo
#10514966

int='^[0-9]+$' # Variable that specify what is only accept (only numbers)

while true :
do

    while :
    do
        read -p 'Range start: ' lower # Prompt user for the start range
        
        if ! [[ $lower =~ $int ]] || [[ $lower -le 1 ]]; # Checks if the user input start range is an integer or is less than 1. If its not either of this keep propmting the user for a start range
            then echo "Invalid start range value. Start range must be an integer greater than 1. Please try again."

        else
            break

        fi

    done


    while :
    do
        read -p 'Range end: ' upper # Prompt user for the end range

        if ! [[ $upper =~ $int ]] || [[ $upper -le 1 ]]; # Checks if the user input end range is an integer or is less than 1. If its not either of this keep propmting the user for a end range
            then echo "Invalid end range value. end range must be an integer greater than 1. Please try again."
        
        else
            break
        
        fi

    done

    num=($upper-$lower) # Find the variable between the given range and store it in the num variable

    if [[ $lower -gt $upper ]] || [[ $num -ge 1 ]]; # Checks if the lower range is greater than the upper range OR if num is greater than 1
        then echo "Invalid end range value, Start range must be an integer and at least 2 digits grate than the start range. Please try again."

    else
        break

    fi


done


echo "you have selected the range $lower - $upper"


for a in $(seq $lower $upper)
do
    flag=0
    for i in $(seq 2 $(expr $a - 1)) # For every number in the ranges given -1 is taken away from it until it reaches 0
    do 
        if [ $(expr $a % $i) -eq 0 ] # Check if the the numbers are equal to 0 then change the flag variable to 1 and break out of the loop
        then
            flag=1
            break

        fi

    done


    if [ $flag -eq 0 ] # Check if flag is equal to 0 store if not keep going in a loop
        then
        prime+=("["$a"]") # Gather the prime numbers and store it in the prime variable

    fi

done

count=${#prime[@]} # Count how much prime numbers there are in the given range

echo -e "$count prime number(s) were found between $lower and $upper, these being:\n${prime[@]}\n"

exit 0