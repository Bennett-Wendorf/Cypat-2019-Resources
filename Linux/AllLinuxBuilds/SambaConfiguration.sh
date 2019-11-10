#!/bin/bash     

clear

echo "-----Samba Configuration-----"

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



function configureSamba() {

    #Allow ports to UFW firewall. UFW must be enabled
    echo ""
    echo "Add the following ports to firewall for samba? [Y\N]"
    echo "UPD/137 - used by nmbd"
    echo "UPD/138 - used by nmbd"
    echo "UPD/139 - used by nmbd"
    echo "UPD/145 - used by nmbd"
    read firewallYN

    if [ "${firewallYN^^}" = "Y" ]; then
        sudo ufw allow 137/udp
        sudo ufw allow 138/udp
        sudo ufw allow 139/udp
        sudo ufw allow 145/udp
    fi
    echo ""
    echo "NOTE: Remember to property configure shares in /etc/samba/smb.conf. Refer to Additional Configuration Guide"
    echo "Press any key to continue..."
    read continueYN
}   

if [ $debug_mode = true ]; then
   echo "Debugging Enabled"
   fi
echo "Is Samba Required?"
read sambaYN

echo "Samba Configuration"

if [ "${sambaYN^^}" = "Y" ]; then
    echo "Installing Samba"
    if $debug_mode ; then
        sudo apt-get install samba -y 
        sudo apt-get install system-config-samba -y 
    else
        sudo apt-get install samba -y -qq
        sudo apt-get install system-config-samba -y -qq
    fi
    echo "Samba Installed"
    configureSamba
else
    echo "Uninstalling Samba.."
    sleep 2
    sudo apt-get purge samba -y 
	sudo apt-get purge samba-common -y  
	sudo apt-get purge samba-common-bin -y 
    clear
    echo "Samba Uninstalled"
fi

