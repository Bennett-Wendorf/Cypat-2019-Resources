#!/bin/bash

#Updates
function update {
    echo "Updating..."
    sudo apt-get update
    sudo apt-get upgrade
    clear
    echo "Update Complete"
}

function sambaConfig {
    if [ "${sambaYN^^}" = "Y"]; then
        sudo apt-get install samba -y -qq
	    sudo apt-get install system-config-samba -y -qq
	    sudo cp /etc/samba/smb.conf ~/Desktop/
        
        #TODO: Configure Samba Configuration
	  
    fi

}

function automaticConfiguration {
    echo "Automatic Configuration"
    
    echo "Enter in [Y]es or [N]o"
    echo ""
    
    echo "Install General Updates for Ubuntu? (Firefox, Packages, Security Patches, LibreOffice)"
    read updateYN

    echo "Is Samba Required?"
    read sambaYN

    echo "Is SSH Required?"
    read sshYN

    echo "Is FTP Required?"
    read ftpYN

    echo "Are MP3s Restricted? (Will not delete without confirmation)"
    read mp3YN

    echo "Are .mov/.mp4 Restricted? (Will not delete without confirmation)"
    read videoYN

    echo "Does UTW Firewall Need To Be Enabled?"
    read utwfirewallYN

    echo "Automatically Delete Malicious Packages? (You will be given the option of which to delete)"
    read packageRemYN

    echo "Is VNC Required?"
    read vncYN
    
    echo "Disable Guest Account?"
    read guestYN

    echo "Enfore Password Requirements? (Max = 7, Min = 90, Warn = 14)"
    read enforcePasswordReqYN

    echo "Verify User Integrity?"
    read userIntegrityYN

    echo "Lock out root user? (Sudo will still work if [Y])"
    read rootLockYN

    echo ""
    echo "Starting Automatic Configuration...."
    sleep 1

    #Updates
    if [ "${updateYN^^}" = "Y" ]; then
        update
    else
        echo "Skipping Updates"
    fi

    if [ "${sambaYN^^}" = "Y" ]; then
        sambaConfig
    else
        echo "Uninstalling Samba.."
        sleep 2
        sudo apt-get purge samba -y -qq
	    sudo apt-get purge samba-common -y  -qq
	    sudo apt-get purge samba-common-bin -y -qq
    fi

    #TODO: Finish Adding Features

}


echo ""
echo "Cypat 2019 Linux Utility"
echo "########################"*
echo "1. Automatic Configuration"
echo "2. Manual Configuration"
echo "3. Get Current Status"
echo ""

printf 'Selection:> '
read -r usercommand

echo ""

clear

if [ "$usercommand" = "1" ]; then
    automaticConfiguration

elif [ "$usercommand" = "2" ]; then
   echo "Not Supported"

elif [ "$usercommand" = "3" ]; then
    echo "Not Supported Yet"
fi