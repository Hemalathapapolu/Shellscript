#!/bin/bash
DIRECTORY=/tmp

if [ -d $DIRECTORY ]
then " Diretory exits "
else " check the directory exit or not "
fi
FILE=$( find $DIRECTORY -name "*.log" -mtime +14)

while IFS= read -r line
do
echo " Logs to delete: $line "
rm -rf $line
done <<< $FILE