#!/bin/bash        

THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
DIR=`dirname "${THIS}"`

automaticConfiguration() {
    echo "Automatic Configuration"
    
    echo "Enter in [Y]es or [N]o"
    echo ""
    
    echo "Install General Updates for Ubuntu? (Firefox, Packages, Security Patches, LibreOffice)"
    read updateYN

    echo "Is OpenSSH Required?"
    read sshYN

    echo "Is VSFTP Required?"
    read ftpYN

    echo "Are MP3s Restricted? (Will not delete files without confirmation)"
    read mp3YN

    echo "Are .mov/.mp4 Restricted? (Will not delete files without confirmation)"
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

    #samba
    clear

    sudo bash $DIR/AllLinuxBuilds/SambaConfiguration.sh  
    

    #TODO: Finish Adding Features

}

debug_mode=false

for arg in "$@"
do
    if [ "$arg" == "--debug" ] 
    then
        echo "Advanced Debugging Has Been Enabled!"
        debug_mode=true
        sleep 1 
    fi
done



echo ""
echo "Cypat 2019 Linux Utility"
echo "########################"
echo "1. Automatic Configuration"
echo "2. Manual Configuration"
echo "3. Get Current Status"
echo ""

printf 'Selection:> '
read -r usercommand

echo ""

clear

if [ "$usercommand" = "1" ]; then
    echo "Automatic Configuration is Currently Disabled Due To Instability"
    #automaticConfiguration

elif [ "$usercommand" = "2" ]; then
   clear
   echo "Select a Utility: "
   echo "########################"
   echo "1. Samba Configuration"
   echo "2. User Validation"
   echo ""

  
   printf 'Selection:> '
   read -r manualChoice


   #samba
   if [ "${manualChoice}" = "1" ]; then

        if $debug_mode ; then
            sudo bash ./AllLinuxBuilds/SambaConfiguration.sh --debug
        else
            sudo bash ./AllLinuxBuilds/SambaConfiguration.sh 
        fi

    fi

    #user account verification
    if [ "${manualChoice}" = "2" ]; then

        if $debug_mode ; then
            sudo bash ./AllLinuxBuilds/VerifyAccounts.sh --debug
        else
            sudo bash ./AllLinuxBuilds/VerifyAccounts.sh 
        fi
   
   
    fi

elif [ "$usercommand" = "3" ]; then
    echo "Not Supported Yet"
fi