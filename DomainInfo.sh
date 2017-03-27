#!/bin/bash
#
# Usage: cat FILENAME | ./DomainNS.sh > /File-Out
#
# The input file needs to be a simple, single column list of domain names.
#

queryserver="8.8.8.8"

# Print "Header"
printf "Domain","SOA","Nameserver","MX","SPF","TXT\n------------","-----","-----------------","------","-----","----\n"

# Loop through each item in the input (Piped input)
while read domain; do

# Perform dig on current $domain for NS records
for soa in `dig @$queryserver $domain soa +short`
do
        serverauthority+="$soa "
done

# Perform dig on current $domain for NS records
for ns in `dig @$queryserver $domain ns +short`
do
	nameserver+="$ns "
done

# Perform dig on current $domain for MX records

mxtemp=1
for mx in `dig @$queryserver $domain mx +short`
do
  if [ $(($mxtemp%2)) == 0 ]
    then
	mxrecord+="$mx "
  fi

mxtemp=$((mxtemp+1))

done

# Perform dig on current $domain for MX records
for spf in `dig @$queryserver $domain spf +short`
do
	spfrecord+="$spf "
done

# Perform dig on current $domain for TXT records
for txt in `dig @$queryserver $domain txt +short`
do
	txtrecord+="$txt "
done

# Print Domain Name with the Registered Nameserver
printf "$domain,$serverauthority,$nameserver,$mxrecord,$spfrecord,$txtrecord\n"

# "Reset" nameserver variable to UNREGISTERED in case the next domain does not have a NS record
serverauthority=' '
nameserver=' '
mxrecord=' '
spfrecord=' '
txtrecord=' '
done

