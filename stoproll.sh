#!/bin/bash

# Find and terminate all rpitx processes
sudo pkill -f rpitx

# Find and terminate all screen sessions related to rpitx
screen -ls | grep rpitx_session | awk -F. '{print $1}' | xargs kill

# Find and terminate the rick.sh script
sudo pkill -f rick.sh

echo "Stopped all rpitx processes, screen sessions, and rick.sh script"
