#!/bin/bash

clear

function showIPs {
    cat $log | awk '{ print $1}'
}


function analyzeMenu {

echo Analyzing logs from "$log" file

while true
do
    echo 
    echo -e "\n***************************\n"
    echo -e "choose an option: \n"
    echo    "1- Show All IPs"
    read selection
    
    case $selection in
    1) showIPs;;
    *) echo you Entered Invalid Selection, try again;;
    
    esac
    
done
}

function getFile {
echo -e "Please select the input log:\n"
ls -p | grep -w log
echo
read log

if [ ! -f $log ]; then
    echo -e "\nFile not found!\n"
    echo -e "Please try again and make sure log file is available in directory"
    getFile
else
    analyzeMenu
fi
}

echo "*************************"
echo -e "This Program can be analyze a apache log file\n"
getFile