#!/bin/bash   

clear 

echo "-----Update Utility-----"

THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
SCRIPTDIR=`dirname "${THIS}"`

#set debug mode to false (will change to true --debug argument is specified)
debug_mode=false

for arg in "$@"
do
    if [ "$arg" == "--debug" ] 
    then
        debug_mode=true
    fi
done


if [ $debug_mode = true ]; then
    echo "Updating..."
    sudo apt-get update 
    sudo apt-get upgrade 
    sudo apt-get -V -y install firefox 
else
    sudo apt-get update -qq
    sudo apt-get upgrade -qq
    sudo apt-get -V -y install firefox -qq
fi


clear
echo "Update Complete"
sleep 4