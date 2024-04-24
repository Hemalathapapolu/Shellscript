#!/bin/bash
USERID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME.log

VALIDATE(){
    if ( $1 -ne 0 )
    then 
        echo "$2 is Failure"
    else
        echo "$2 is Success"
    fi
}

if ($USERID -ne 0)
then
    echo "Try with root access"
else
    echo "you are root user"
fi

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing Mysql"

