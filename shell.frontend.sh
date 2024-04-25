#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S) 
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
echo " db password is:"
read -s mysql_root_password
VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 is  ....$R Failure $N"
        exit 1
    else
        echo -e "$2 is .. $G SUCCESS $N"
    fi
}
if [ $USERID -ne 0 ]
    then
        echo " Run with Root access"
        exit 1
    else
        echo "you are root user"
    fi
    dnf install nginx -y &>>$LOGFILE
    VALIDATE $? "Installing nginx"

    systemctl enable nginx &>>$LOGFILE
    VALIDATE $? "Enabling nginx"

    systemctl start nginx &>>$LOGFILE
    VALIDATE $? "Starting nginx"

    rm -rf /usr/share/nginx/html/* &>>$LOGFILE
    VALIDATE $? "Removing existing content"

    curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
    VALIDATE $? "Downloading frontend code"

    cd /usr/share/nginx/html &>>$LOGFILE
    unzip /tmp/frontend.zip &>>$LOGFILE
    VALIDATE $? "Extracting frontend code"

    cp /home/ec2-user/Shellscript/expense.config /etc/nginx/default.d/expense.config &>>$LOGFILE
    VALIDATE $? "Copied expense conf"

    systemctl restart nginx &>>$LOGFILE
    VALIDATE $? "Restarting nginx"
