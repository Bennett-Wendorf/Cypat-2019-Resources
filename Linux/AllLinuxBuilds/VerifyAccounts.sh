#!/bin/bash   

clear
echo "User Validation Utility"
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


declare -a csvAdmins
declare -a csvUsers
declare -a csvAllUsers
declare -a currentAdmins
declare -a currentUsers

echo ""

function importUsersFromCSV() {
    OLDIFS=$IFS
    export IFS=","

    #index
    i=1
    while read -r admin password user userpassword
    do  

      #skip if index is 1....skips column titles
      test $i -eq 1 && ((i=i+1)) && continue

      csvAdmins+=($admin)
      csvUsers+=($user)
      csvAllUsers+=($admin)
      csvAllUsers+=($user)
    done < "${SCRIPTDIR}/UserAccounts.csv"


    IFS=$OLDIFS


}

function getLinuxUsers() {
    #get list of current administrators
    if [ $debug_mode = true ]; then
      echo "[Debug]: Getting Current Admins"
    fi
    read ADMINOUTPUT <<< $(grep '^sudo:.*$' /etc/group | cut -d: -f4)
    IFS=',' 
    read -ra currentAdmins <<< "$ADMINOUTPUT" # str is read into an array as tokens separated by IFS

    #get all users (administrators and standard users combined)
    if [ $debug_mode = true ]; then
      echo "[Debug]: Getting All Users"
    fi
    while IFS=: read -r user _ uid _ 
    do
        (( uid > 999 && uid != 65534 )) && currentUsers+=( "$user" )
        (( uid > 999 && uid != 65534 )) && allUsers+=( "$user" )
    done < "/etc/passwd"


    #remove administrators from all users list in order to determine standard users
    if [ $debug_mode = true ]; then
      echo "[Debug]: Getting Current Admins"
    fi
    for i in "${!currentAdmins[@]}"; do
        for j in "${!currentUsers[@]}"; do
              if [[ ${currentAdmins[$i]} = "${currentUsers[$j]}" ]]; then
                unset currentUsers[j]               
              fi
        done
    done
}

function CheckAndRemoveUnauthorizedUsers() {
    userIsValid=true
    for i in "${!allUsers[@]}"; do
        userIsValid=false
        for j in "${!csvAllUsers[@]}"; do
            if [[ ${allUsers[$i]} = "${csvAllUsers[$j]}" ]]; then
                userIsValid=true
            fi
        done

        if [ "$userIsValid" = false ] ; then
        echo ""
        echo "Flagged Account!"
        echo "User: " ${allUsers[$i]}
        echo "Reason: Account is not suppose to exist"
        echo "[1. Delete] [2. Ignore]"
        read userSelection

        if [ $userSelection = "1" ]; then
            echo "Are you sure you want to delete ${allUsers[$i]}? [Y\N]"
            read deleteYN

            if [ "${deleteYN^^}" = "Y" ]; then
              sudo deluser ${allUsers[$i]}
              if [ $debug_mode = true ]; then
                  echo "[Debug]: Removed User ${allUsers[$i]}"
              fi
            fi
        fi

        if [ $userSelection = "2" ]; then
            if [ $debug_mode = true ]; then
                echo "[Debug]: Ignoring User ${allUsers[$i]}"
            fi

        fi


      
      fi

    done   
}

function CheckAndRemovePrivilegedUsers() {

  #if user is an admin and should not be
  for i in "${!currentAdmins[@]}"; do
    for j in "${!csvUsers[@]}"; do
          if [[ ${currentAdmins[$i]} = "${csvUsers[$j]}" ]]; then
              echo ""
              echo "Flagged Account!"
              echo "User: " ${csvUsers[$j]}
              echo "Reason: User is an Admin, and should not be."
              echo "[1. Delete] [2. Demote] [3. Ignore]"
              read userSelection
              
              if [ $userSelection = "1" ]; then
                   echo "Are you sure you want to delete ${currentAdmins[$i]}? [Y\N]"
                    read deleteYN

                    if [ "${deleteYN^^}" = "Y" ]; then
                      sudo deluser ${currentAdmins[$i]}
                      if [ $debug_mode = true ]; then
                          echo "[Debug]: Removed User ${currentAdmins[$i]}"
                      fi
                  fi
              fi

              if [ $userSelection = "2" ]; then
                  sudo deluser ${csvUsers[$j]} sudo
                  if [ $debug_mode = true ]; then
                      echo "[Debug]: Demoted User ${currentAdmins[$i]} to Standard Account"
                  fi

              fi

              if [ $userSelection = "3" ]; then
                  if [ $debug_mode = true ]; then
                      echo "[Debug]: Ignoring User ${currentAdmins[$i]}"
                  fi
              
              fi

          fi
          
    done

  done


  for i in "${!currentUsers[@]}"; do
    for j in "${!csvAdmins[@]}"; do
          if [[ ${currentUsers[$i]} = "${csvAdmins[$j]}" ]]; then
              echo ""
              echo "Flagged Account!"
              echo "User: " ${currentUsers[$i]}
              echo "Reason: User is a standard account. Should be an admin!"
              echo "[1. Delete] [2. Promote] [3. Ignore]"
              read userSelection
              
              if [ $userSelection = "1" ]; then
                  echo "Are you sure you want to delete ${allUsers[$i]}? [Y\N]"
                  read deleteYN

                  if [ "${deleteYN^^}" = "Y" ]; then
                      sudo deluser ${allUsers[$i]}
                    if [ $debug_mode = true ]; then
                          echo "[Debug]: Removed User ${allUsers[$i]}"
                    fi
                    if [ $debug_mode = true ]; then
                          echo "[Debug]: Removed User ${currentUsers[$i]}"
                    fi 
                  fi
              fi

              if [ $userSelection = "2" ]; then
                  sudo adduser ${currentUsers[$i]} sudo
                  if [ $debug_mode = true ]; then
                      echo "[Debug]: Promoted User ${currentUsers[$i]} to Admin Account"
                  fi

              fi

              if [ $userSelection = "3" ]; then
                  if [ $debug_mode = true ]; then
                    echo "[Debug]: Ignoring User ${currentUsers[$i]}"
                  fi
              fi
          fi
    done

  done

}

#__main__
importUsersFromCSV
getLinuxUsers

if [ $debug_mode = true ]; then
  echo "[Debug]: Found Admins: ${currentAdmins[@]}"
  echo "[Debug]: Standard Users: ${currentUsers[@]}"

fi

CheckAndRemoveUnauthorizedUsers
CheckAndRemovePrivilegedUsers
echo "User Verification Complete!"
sleep 1