#!/bin/bash   

debug_mode = $1

clear
echo "Update Utility"

echo "Updating..."
sudo apt-get update -qq
sudo apt-get upgrade -qq
sudo apt-get -V -y install firefox

clear
echo "Update Complete"
sleep 4