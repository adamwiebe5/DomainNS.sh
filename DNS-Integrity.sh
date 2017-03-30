#!/bin/bash
#
# Usage: ./DomainNS.sh [DomainName-List] > /File-Out
#
# The input file needs to be a simple, two column list of DNS names, and the record type (A,TXT,SRV)
#

queryServer="129.130.254.2"
fqdnList=`cat $1`

while read i; do

IFS=',' read y z <<<"$i"

currentRecord="$y"
recordType="$z"

digResult=`dig @"$queryServer" "$currentRecord" "$recordType" +short`
digResult="${digResult//$'\n'/;}"
echo "$recordType"',,'"$currentRecord"','"$digResult"

done <<< "$fqdnList"

