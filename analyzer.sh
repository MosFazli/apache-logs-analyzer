#!/bin/bash

# This Bash Script is useful for reading Apache log files
# Developed By @MosFazli
# 30 December 2021

# clear screen for start app
clear

# Fucntion 1: This function get first variable of each Rows (IP) and count them, show count of non-repetition IPs
# Show All IP Request, show sorting IPs without repetition and last part Saved it into directory with allIPs.txt file
function showIPs {
    cat $log | awk '{ print $1}' | sort | uniq | wc | awk '{print $1 " IPs without repetition found" }'
    cat $log | awk -F\" '{ print $1 }'| wc | awk '{print "All of IPs are: " $1}'
    cat $log | awk '{ print count "times {" $1 "} IP is repeated."}' | sort -r | uniq -c | sort -r
    cat $log | awk '{ print $1}' | uniq > allIPs.txt
}


# Function 2: This function get forth part of each Rows (Days and Times) and cut it for get just Days, then first count days
#  next show all of them and for the last part save it with allDays.txt file in directory
function showAllDays {
    awk '{print count "times {" $4 "} Day is repeated."}' $log | cut -d: -f1 | uniq -c  | wc | awk '{print $1 " Days found:" }'
    awk '{print count "times {" $4 "} Day is repeated."}' $log | cut -b 1-6,9-19 | sort | uniq -c  | sort -nr
    awk '{print count "times {" $4 "} Day is repeated."}' $log | cut -b 1-6,9-19 | sort | uniq -c  | sort -nr > allDays.txt
}

# Function 3: This function like pervious function get forth part of each Rows (Days and Times) but this time cut it for separate 
# Times, then sort them based on counts and show them afterwards save them into directory with pickHours.txt file
function showpickHours {
    echo -e "Number of requests and Pick times in Order are:"
    awk '{print count  $4 }' $log | cut -b 14-15 | sort | uniq -c | sort -nr
    awk '{print count  $4 }' $log | cut -b 14-15 | sort | uniq -c | sort -nr > pickHours.txt
}

# Function 4: This funtion Shows Request types, It has a simple function, first get sixth part of each Rows (Request Types),
# first counts them, next sort them based on repeated and shows them, Last save them into requestTypes.txt file in directory
function showRequestTypes {
    cat $log | awk '{ print $6}'  | wc | awk '{print $1 " Requests found:" }'
    cat $log | awk '{ print count "times {" $6 "} Request is repeated."}' | sort -r | uniq -c | sort -r
    cat $log | awk '{ print count "times {" $6 "} Request is repeated."}' | sort -r | uniq -c | sort -r > requestTypes.txt
}

# Function 5: This function Shows Top IPs, like function 1 that just shows IPs, this function first count non-repetition IPs
# next count all of IPs, then shows 20 IPs that are more duplicated than others, afterwards save it into TopIPs.txt file in directory
function showTopIPs {
    cat $log | awk '{ print $1}' | sort | uniq | wc | awk '{print $1 " IPs without repetition found" }'
    cat $log | awk -F\" '{ print $1 }'| wc | awk '{print "All of IPs are: " $1}'
    echo Top 20 IPs:
    awk '{print count "times {" $1 "} IP is repeated."}' $log | sort | uniq -c  | sort -nr | head -n 20
    awk '{print count "times {" $1 "} IP is repeated."}' $log | sort | uniq -c  | sort -nr | head -n 20 > TopIPs.txt
}

#Function 6: This funtion Shows Top Refrences, first get All refrences with awk and then count them, then shows 10 refrences
# that are more duplicated than others, in last part save them in directory with TopRefrences.txt name
function showTopRefrences { 
    cat $log | awk -F\" '{ print $4 }'| grep -v '-'| wc | awk '{print "All of refrences are: " $1}'
    echo Top 10 Refrences:
    cat $log | awk -F\" '{ print  $4 }'| grep -v '-'| sort | uniq -c | sort -nr | head -n 10
    cat $log | awk -F\" '{ print  $4 }'| grep -v '-'| sort | uniq -c | sort -nr | head -n 10 > TopRefrences.txt
}

# Function 7: 
function showTopUserAgents {
    echo Top 10 user agents:
	cat $log | awk -F\" '{ print count $6 }' | sort | uniq -c | sort -nr | head -n 10
	cat $log | awk -F\" '{ print count $6 }' | sort | uniq -c | sort -nr | head -n 10 > TopUserAgents.txt
}

function showPopularBrowsers {
    echo Top 10 Popular Browsers:
    cat $log | awk '{count[$(NF)]++} END {for (browser in count) print browser, count[browser]}' | sort -k 2nr | head -n 10
    cat $log | awk '{count[$(NF)]++} END {for (browser in count) print browser, count[browser]}' | sort -k 2nr | head -n 10 > PopularBrowsers.txt
}

function showMostVisitedURLs {
    echo 10 Most URLs Visited:
    awk '{count[$7]++} END {for (url in count) print url, count[url]}' $log | sort -k 2nr | head -n 10
    awk '{count[$7]++} END {for (url in count) print url, count[url]}' $log | sort -k 2nr | head -n 10 > MostVisitedURLs.txt
}

function visitorsOS {
    echo Top 10 visitors Opeation Systems:
    awk '{count[$13]++} END {for (os in count) print os, count[os]}' $log | sort -k 2nr | head -n 10
    awk '{count[$13]++} END {for (os in count) print os, count[os]}' $log | sort -k 2nr | head -n 10 > VisitorsOS.txt
}

function countOfUniqueVisitors {
    echo Count of unique Visitors:
	cat $log | awk '{ print $1 }'  |  sort | uniq | wc -l
}


function filterRefrence { 
    echo "Total visits of $link : " | tr '[:upper:]' '[:lower:]' 
    word="${link,,}"
    #echo $word
    cat $log | egrep $word | awk -F\" '{ print $4 }' | grep -v '-'| wc -l
    cat $log | egrep $word | awk -F\" '{ print  $4 }'| grep -v '-'| sort | uniq -c | sort -nr | head -n 10
    cat $log | egrep $word | awk -F\" '{ print  $4 }'| grep -v '-'| sort | uniq -c | sort -nr | head -n 10 > Filter$word.txt
}


function analyzeMenu {

echo Analyzing logs from "$log" file

while true
do
    echo 
    echo -e "\n******************************************\n"
    echo    "------------------------------------------"
    echo -e "|           choose an option             |"
    echo    "|----------------------------------------|"
    echo    "|1 Show All IPs                          |"
    echo    "|----------------------------------------|"
    echo    "|2 Show All Days available               |"
    echo    "|----------------------------------------|"
    echo    "|3 Show All Pick Hours                   |"
    echo    "|----------------------------------------|"
    echo    "|4 Show types of Requests                |"
    echo    "|----------------------------------------|"
    echo    "|5 Show The 20 most visited IPs          |"
    echo    "|----------------------------------------|"
    echo    "|6 Show Top 10 referrers                 |"
    echo    "|----------------------------------------|"
    echo    "|7 Show Top 10 user agents               |"
    echo    "|----------------------------------------|"
    echo    "|8 Show Most Popluar Browsers            |"
    echo    "|----------------------------------------|"
    echo    "|9 Show Most Visited URLs                |"
    echo    "|----------------------------------------|"
    echo    "|10 Show Most Visitors Operation Systems |"
    echo    "|----------------------------------------|"
    echo    "|11 Show count of unique Visitors        |"
    echo    "|----------------------------------------|"
    echo    "|12 Filter Refrences                     |"
    echo    "------------------------------------------"
    
    read -p "choise: " selection
    
    case $selection in
    1) showIPs;;
    2) showAllDays;;
    3) showpickHours;;
    4) showRequestTypes;;
    5) showTopIPs;;
    6) showTopRefrences;;
    7) showTopUserAgents;;
    8) showPopularBrowsers;;
    9) showMostVisitedURLs;;
    10) visitorsOS;;
    11) countOfUniqueVisitors;;
    12)echo Enter URL to filter search:;read link; filterRefrence;;
    *) echo you Entered Invalid Selection, try again;;
    
    esac
    
done
}

function getFile {
echo -e "Please select the input log:\n"
ls -p | grep -w log
echo
read log
#log="apache.log"

if [ ! -f $log ]; then
    echo -e "\nFile not found!\n"
    echo -e "Please try again and make sure log file is available in directory"
    getFile
else
    analyzeMenu
fi
}

echo -e "\nThis Program can be analyze a apache log file\n"
getFile