#!/bin/bash
#John Aguinaldo
#10514966


parseVowels() {

totalword=`wc -w < $filename`

for word in $(cat $1); do #The $1 variable contains passage.txt which was passed to the function
    if [ ${#word} -ge 4 ]; then #Get the length of the current word and see if it is -ge to 4
        ((wordsgefour++)) #If yes, increment the counter

        cut=$( echo $word | cut -d, -f 1)
        parse=$( echo $cut | cut -d. -f 1)

        characters+=($parse) #Store the words that are 4 words or greater in to the characters variable

        vowelCount=$( echo $parse | grep -io "[aeiouAEIOU]" | wc -w) #Count the vowels in that word

        
        if [ $vowelCount -eq 0 ] #Checks if the word contain 0 vowels
            then
                zerovowel+=("["$parse"]") #Store the words that does not contain any vowels into the zerovowel variable


        elif [ $vowelCount -eq 1 ] #Checks if the word contain 1 vowels
             then
                onevowel+=("["$parse"]") #Store the words that contains 1 vowel into the onevowel variable
                        
                        
        elif [ $vowelCount -eq 2 ] #Checks if the word contain 2 vowels
            then
                twovowel+=("["$parse"]") #Store the words that contains 2 vowels into the twovowel variable

                
        elif [ $vowelCount -eq 3 ] #Checks if the word contain 3 vowels
            then
                threevowel+=("["$parse"]") #Store the words that contains 3 vowels into the threevowel variable


        elif [ $vowelCount -eq 4 ] #Checks if the word contain 4 vowels
            then
                fourvowel+=("["$parse"]") #Store the words that contains 4 vowels into the fourvowel variable
                
        elif [ $vowelCount -eq 5 ] #Checks if the word contain 5 vowels
            then
                fivevowel+=("["$parse"]") #Store the words that contains 5 vowels into the fivevowel variable

        fi

        toparse=${#characters[@]} #Count the total number of words
        
    else
        continue #Else skip the current word and do nothing
    fi

done

    #Count the total number of words for each variable
    czv=${#zerovowel[@]} 
    conv=${#onevowel[@]}
    ctv=${#twovowel[@]}
    cthv=${#threevowel[@]}
    cfv=${#fourvowel[@]}
    cfiv=${#fivevowel[@]}

    
    echo -e "The file contains $totalword words, of which $toparse are four letters or more in length. The vowel count for these $toparse words are as follows:\n"
    
    if ! [[ $czv -eq 0 ]] #Checks if the czv variable is not 0
        then echo -e "$czv contain 0 vowels, these being:\n${zerovowel[*]}\n"

    else #If czv variable does not contain anything prompt user that there is no words
        echo -e "There are no words that contain 0 vowels\n"

    fi


    if ! [[ $conv -eq 0 ]] #Checks if the conv variable is not 0
        then echo -e "$conv contain 1 vowels, these being:\n${onevowel[*]}\n"

    else #If conv variable does not contain anything prompt user that there is no words
        echo -e "There are no words that contain 1 vowels\n"

    fi


    if ! [[ $ctv -eq 0 ]] #Checks if the ctv variable is not 0
        then echo -e "$ctv contain 2 vowels, these being:\n${twovowel[*]}\n"

    else #If ctv variable does not contain anything prompt user that there is no words
        echo -e "There are no words that contain 2 vowels\n"

    fi


    if ! [[ $cthv -eq 0 ]] #Checks if the cthv variable is not 0
        then echo -e "$cthv contain 3 vowels, these being:\n${threevowel[*]}\n"

    else #If cthv variable does not contain anything prompt user that there is no words
        echo -e "There are no words that contain 3 vowels\n"

    fi
    

    if ! [[ $cfv -eq 0 ]] #Checks if the cfv variable is not 0
        then echo -e "$cfv contain 4 vowels, these being:\n${fourvowel[*]}\n"

    else #If cfv variable does not contain anything prompt user that there is no words
        echo -e "There are no words that contain 4 vowels\n"

    fi


    if ! [[ $cfiv -eq 0 ]] #Checks if the cfiv variable is not 0
        then echo -e "$cfiv contain 5 vowels, these being:\n${fivevowel[*]}\n"

    else #If cfiv variable does not contain anything prompt user that there is no words
        echo -e "There are no words that contain 5 vowels\n"

    fi

}


while true :
    do
        read -p 'Please enter a file name to parse: ' filename #Prompt user to input a file name to parse and store it in the filename variable

    if ! [[ -f $filename ]]; #Checks if user input exists in the location and if it doesn't prompt the user that it does not exist otherwise keeps prompting the user to put a file name to parse
        then echo "A file name of $filename does not exist in this location. Please try again."

    else
        parseVowels $filename #Calls in the function with the following user file name input
        exit 1

    fi

done

exit 0