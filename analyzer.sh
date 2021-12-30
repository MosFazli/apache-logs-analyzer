#!/bin/bash

clear

function showIPs {
    cat $log | awk '{ print $1}' | sort | uniq | wc | awk '{print $1 " IPs without repetition found" }'
    cat $log | awk -F\" '{ print $1 }'| wc | awk '{print "All of IPs are: " $1}'
    cat $log | awk '{ print count "times {" $1 "} IP is repeated."}' | sort -r | uniq -c | sort -r
    cat $log | awk '{ print $1}' | uniq > allIPs.txt
}


function showAllDays {
    awk '{print count "times {" $4 "} Day is repeated."}' $log | cut -d: -f1 | uniq -c  | wc | awk '{print $1 " Days found:" }'
    awk '{print count "times {" $4 "} Day is repeated."}' $log | cut -b 1-6,9-19 | sort | uniq -c  | sort -nr
    awk '{print count "times {" $4 "} Day is repeated."}' $log | cut -b 1-6,9-19 | sort | uniq -c  | sort -nr > allDays.txt
}


function showpickHours {
    echo -e "Number of requests and Pick times in Order are:"
    awk '{print count  $4 }' $log | cut -b 14-15 | sort | uniq -c | sort -nr
    awk '{print count  $4 }' $log | cut -b 14-15 | sort | uniq -c | sort -nr > pickHours.txt
}

function showRequestTypes {
    cat $log | awk '{ print $6}'  | wc | awk '{print $1 " Requests found:" }'
    cat $log | awk '{ print count "times {" $6 "} Request is repeated."}' | sort -r | uniq -c | sort -r
    cat $log | awk '{ print count "times {" $6 "} Request is repeated."}' | sort -r | uniq -c | sort -r > requestTypes.txt
}

function showTopIPs {
    cat $log | awk '{ print $1}' | sort | uniq | wc | awk '{print $1 " IPs without repetition found" }'
    cat $log | awk -F\" '{ print $1 }'| wc | awk '{print "All of IPs are: " $1}'
    echo Top 20 IPs:
    awk '{print count "times {" $1 "} IP is repeated."}' $log | sort | uniq -c  | sort -nr | head -n 20
    awk '{print count "times {" $1 "} IP is repeated."}' $log | sort | uniq -c  | sort -nr | head -n 20 > TopIPs.txt
}

function showTopRefrences { 
    cat $log | awk -F\" '{ print $4 }'| grep -v '-'| wc | awk '{print "All of refrences are: " $1}'
    echo Top 10 Refrences:
    cat $log | awk -F\" '{ print  $4 }'| grep -v '-'| sort | uniq -c | sort -nr | head -n 10
    cat $log | awk -F\" '{ print  $4 }'| grep -v '-'| sort | uniq -c | sort -nr | head -n 10 > TopRefrences.txt
}

function showTopUserAgents {
    echo Top 10 user agents:
	cat $log | awk -F\" '{ print count $6 }' | sort | uniq -c | sort -nr | head -n 10
	cat $log | awk -F\" '{ print count $6 }' | sort | uniq -c | sort -nr | head -n 10 > TopUserAgents.txt
}

function countOfUniqueVisitors {
    echo Count of unique Visitors:
	cat $log | awk '{ print $1 }'  |  sort | uniq | wc -l
}




function analyzeMenu {

echo Analyzing logs from "$log" file

while true
do
    echo 
    echo -e "\n***************************\n"
    echo -e "choose an option: \n"
    echo    "1- Show All IPs"
    echo    "2- Show All Days available"
    echo    "3- Show All Pick Hours"
    echo    "4- Show types of Requests"
    echo    "5- Show The 20 most visited IPs"
    echo    "6- Show Top 10 referrers"
    echo    "7- Show Top 10 user agents"
    echo    "8- Show count of unique Visitors"
    read selection
    
    case $selection in
    1) showIPs;;
    2) showAllDays;;
    3) showpickHours;;
    4) showRequestTypes;;
    5) showTopIPs;;
    6) showTopRefrences;;
    7) showTopUserAgents;;
    8) countOfUniqueVisitors;;
    *) echo you Entered Invalid Selection, try again;;
    
    esac
    
done
}

function getFile {
echo -e "Please select the input log:\n"
ls -p | grep -w log
echo
#read log
log="apache.log"

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