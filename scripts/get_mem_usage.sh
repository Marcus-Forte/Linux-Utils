#!/bin/bash
  
if [[ -z $1   ||  -z $2 ]]
then
        echo "Usage: get_mem_usage.sh 'process call' 'logfile'"
        exit
fi


if [[ -f $2  ]]
then
        rm -i $2
fi

# Run process $1
$1 >/dev/null &
cmdpid=$!
echo "'$1'" is running on "$cmdpid"

# Wait until it finishes. Log memory usage
echo "Process $1 : $(date)" >> $2
while [[ -d "/proc/$cmdpid" ]]
do
        pmap "$cmdpid" | grep total | awk '{print substr($2, 0, length($2)-1)}' | tee -a $2
        sleep 0.5
done
