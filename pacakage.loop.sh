#!/bin/bash
USERID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME.log

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo "$2 is Failure"
        exit 1
    else
        echo "$2 is Success"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Try with root access"
    exit 1
else
    echo "you are root user"
fi

for i in $@
do
    echo " pacakage to install $i "
    dnf list installed $i &>>LOGFILE
    if [ $? -eq 0]
    then 
        echo " $i is already installed .... SKIPING "
    else
        dnf install $i -y &>>$LOGFILE
        VALIDATE $? "Installing $i"
    
    fi
done