#!/bin/bash     

THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
SCRIPTDIR=`dirname "${THIS}"`

declare -a admins
declare -a users

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

echo ${admins[@]}
echo ${users[@]}