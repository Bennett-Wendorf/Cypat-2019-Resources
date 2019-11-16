#!/bin/bash   

clear
echo "Password Validation"
echo ""

THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
SCRIPTDIR=`dirname "${THIS}"`

debug_mode=false

for arg in "$@"
do
    if [ "$arg" == "--debug" ] 
    then
        debug_mode=true
    fi
done

declare -a csvAllUsers
declare -a csvAllUsersPasswords


echo ""

function importUsersFromCSV() {
    OLDIFS=$IFS
    export IFS=","

    #index
    i=0
    while read -r Admins AdminPasswords Users UserPasswords
    do  

      #skip if index is 1....skips column titles
      test $i -eq 1 && ((i=i+1)) && continue

      
      csvAllUsers+=($Admins)
      csvAllUsersPasswords+=($AdminPasswords)
      csvAllUsers+=($Users)
      csvAllUsersPasswords+=($UserPasswords)
      
    done < "${SCRIPTDIR}/UserAccounts.csv"


    IFS=$OLDIFS


}




   
function verifyPassword(){
    containsSpecial=false
    for i in "${!csvAllUsers[@]}"; do
        containsSpecial=false
         for j in "${!csvAllUsersPasswords[@]}"; do
           if [[ ${csvAllUsersPasswords[$j]} == *['!'@#\$%^\&*()_+]* ]]
                then
                echo "${csvAllUsersPasswords[$j]}"
                echo "It contains one of those"
                fi
         done

        if [ "$containsSpecial" = false ] ; then
                   echo "Changing password for ${csvAllUsers[i]}"
                   echo "${csvAllUsers[i]}:Un!quePassw0rd" | chpasswd  
                   read yeah
        fi
    done


}
importUsersFromCSV
echo "${csvAllUsersPasswords[@]}"
verifyPassword


