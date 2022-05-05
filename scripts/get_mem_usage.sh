#!/bin/bash


if [[ -f memlog.txt ]]
then
        rm -i memlog.txt
fi

# Run process $1
$1 >/dev/null &
cmdpid=$!
echo "'$1'" is running on "$cmdpid"

# Wait until it finishes. Log memory usage
echo "Process $1 : $(date)" >> memlog.txt
while [[ -d "/proc/$cmdpid" ]]
do
        pmap "$cmdpid" | grep total | tee -a memlog.txt
        sleep 0.5
done
