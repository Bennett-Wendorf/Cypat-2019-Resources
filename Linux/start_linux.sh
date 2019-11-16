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



for arg in "$@"
do
    if [ "$arg" == "--debug" ]; then
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
    echo "3. Update Software and Packages"
    echo "4. SSH Configuration"
    echo "5: VSFTP Configuration (Not Ready)"
    echo "6: Firewall Configuration (Not Ready)"
    echo "7: Verify Group Policies (Not Ready)"
    echo "8: Remove Prohibited Packages (Not Ready)"
    echo "9: System Account Policy"
    echo "10: File Verification (Not Ready)"
    echo "11: \"Sticky\" Bit Locator (Not Ready)" 
    echo "12: Password Validation (Disabled)"
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


        #update software and packages
        if [ "${manualChoice}" = "3" ]; then

            if $debug_mode ; then
                sudo bash ./AllLinuxBuilds/Update.sh --debug
            else
                sudo bash ./AllLinuxBuilds/Update.sh 
            fi
    
    
        fi


        #configure ssh
        if [ "${manualChoice}" = "4" ]; then

            if $debug_mode ; then
                sudo bash ./AllLinuxBuilds/SSHConfiguration.sh --debug
            else
                sudo bash ./AllLinuxBuilds/SSHConfiguration.sh 
            fi
    
    
        fi

          #system account policy
        if [ "${manualChoice}" = "9" ]; then

            if $debug_mode ; then
                sudo bash ./AllLinuxBuilds/SysAccountPolicy.sh --debug
            else
                sudo bash ./AllLinuxBuilds/SysAccountPolicy.sh 
            fi
    
    
        fi


          #system account policy
        if [ "${manualChoice}" = "-99" ]; then

            if $debug_mode ; then
                sudo bash ./AllLinuxBuilds/VerifyPasswords.sh --debug
            else
                sudo bash ./AllLinuxBuilds/VerifyPasswords.sh 
            fi
    
    
        fi
   
    
elif [ "$usercommand" = "3" ]; then
    echo "Not Supported Yet"
fi