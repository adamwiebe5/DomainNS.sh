#!/bin/bash
#
# Usage: ./DomainNS.sh [DomainName-List] > /File-Out
#
# The input file needs to be a simple, two column list of DNS names, and the record type (A,TXT,SRV)
#

queryServer="10.139.43.255"
fqdnList=`cat $1 | sed -e 's/[^ -~]//g'`

while read i; do
IFS=',' read y z <<<"$i"

currentRecord="$y"
recordType="$z"

digResult=$(dig @$queryServer $currentRecord "$recordType" +short | sort)
digResult="${digResult//$'\n'/;}"
digResult="${digResult//';; Truncated, retrying in TCP mode.'/}"

echo $currentRecord,$digResult,$recordType

done <<< "$fqdnList"

