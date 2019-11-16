#!/bin/bash   

clear 

echo "-----SSH Configuration-----"

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


function configureSSH(){
    if $debug_mode ; then
       echo "Creating Backup SSH Config to Desktop"
       sudo cp /etc/ssh/sshd_config ~/Desktop
    fi
    echo "Permit Root Login? [Y/N]?"
    read rootLoginYN

    if [ "${rootLoginYN^^}" = "Y" ]; then
        sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
    fi

    echo "Limit Password Login Attempts to 6? [Y/N]?"
    read passwordAttemptsYN

    if [ "${passwordAttemptsYN^^}" = "Y" ]; then
        sudo sed -i 's/#MaxAuthTries 6/MaxAuthTries 6/g' /etc/ssh/sshd_config
    fi

}

#__main__

echo "Is OpenSSH Required?"
read sshYN

if [ "${sshYN^^}" = "Y" ]; then
    echo "Installing OpenSSH"
    if [ $debug_mode = true ]; then
        sudo apt-get install openssh-server 
        configureSSH
    else
        sudo apt-get install openssh-server -qq
        configureSSH
    fi

else
    echo "Uninstalling OpenSSH"
    sudo apt-get remove openssh-server

fi