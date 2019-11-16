#!/bin/bash     

clear

echo "-----System Account Policy-----"

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

function configurePolicy(){
    echo "Disable Guest Account? [Y/N]?"
    read guestYN

    if [ "${guestYN^}" = "Y" ]; then
        echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
    fi

    echo "Set Password Minimum Days to 7 [Y/N]?"
    read passminYN

    if [ "${passminYN^}" = "Y" ]; then
        sudo sed -i 's/PASS_MIN_DAYS   0/PASS_MIN_DAYS   7/g' /etc/login.defs
    fi

    echo "Set Password Maximum Days to 90 [Y/N]?"
    read passmaxYN

    
    if [ "${passmaxYN^}" = "Y" ]; then
        sudo sed -i 's/PASS_MAX_DAYS   99999/PASS_MAX_DAYS   90/g' /etc/login.defs
    fi


    echo "Set Password Warning Age to 14 [Y/N]?"
    read passwarnYN

    
    if [ "${passwarnYN^}" = "Y" ]; then
        sudo sed -i 's/PASS_WARN_DAYS   7/PASS_WARN_DAYS   14/g' /etc/login.defs
    fi


}

configurePolicy