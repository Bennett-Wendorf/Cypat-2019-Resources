#!/bin/bash     

THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
SCRIPTDIR=`dirname "${THIS}"`

declare -a admins
declare -a users
declare -a currentAdmins
declare -a currentUsers


#set debug mode to false (will change to true --debug argument is specified)
debug_mode=false

for arg in "$@"
do
    if [ "$arg" == "--debug" ] 
    then
        debug_mode=true
    fi
done


#GET LIST OF USERS FROM CSV FILE
OLDIFS=$IFS
export IFS=","

#index
i=1
while read -r admin password user userpassword
do  

  #skip if index is 1....skips column titles
  test $i -eq 1 && ((i=i+1)) && continue
  admins+=($admin)
  users+=($user)
done < "${SCRIPTDIR}/UserAccounts.csv"

IFS=$OLDIFS



#get list of current administrators

read ADMINOUTPUT <<< $(grep '^sudo:.*$' /etc/group | cut -d: -f4)

IFS=',' 
read -ra currentAdmins <<< "$ADMINOUTPUT" # str is read into an array as tokens separated by IFS



#get all users (administrators and standard users combined)
while IFS=: read -r user _ uid _ 
do
    (( uid > 999 && uid != 65534 )) && currentUsers+=( "$user" )
done < "/etc/passwd"


#remove administrators from all users list in order to determine standard users

for i in "${!currentAdmins[@]}"; do
    for j in "${!currentUsers[@]}"; do
          if [[ ${currentAdmins[$i]} = "${currentUsers[$j]}" ]]; then

            unset currentUsers[j]
                   
          fi
    done
done


echo "Current Admins:"
echo ${currentAdmins[@]}

echo "Standard Users:"
echo ${currentUsers[@]}