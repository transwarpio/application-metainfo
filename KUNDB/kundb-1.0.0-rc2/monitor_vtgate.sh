#!/bin/sh

# must use user "kun" to run this script

if [ "$1" != "olap" -a "$1" != "oltp" -a "$1" != "priv" -a "$1" != "insert" ]; then
	echo "$(basename $0): wrong usage"
	echo "usage: $(basename $0) vtgate_type"
	echo ""
	echo "	vtgate_type: either olap, oltp, priv or insert"	
	exit 1
fi

vtgate_typ="$1"

failure_count=0
while [ 1 -eq 1 ]
do
	status=`ps -A | grep ' vtgate$'`
	if [ -z "$status" ]; then 
		failure_count=$((failure_count+1))
		/usr/local/kunexpr/kundb/cluster/${vtgate_typ}-vtgate-up.sh --no-vtgate-monitor
	else
		failure_count=0
	fi
	if [ "$failure_count" -gt 4 ]; then
		echo "Can't start up vtgate after 5 retries, exit" 
		exit 1
	fi

	sleep 5s
done
