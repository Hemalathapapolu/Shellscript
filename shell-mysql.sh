#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S) 
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
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

dnf install mysql-server -y &>>LOGFILE
VALIDATE $? "Installing Mysql-server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling Mysql-server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL Server"

mysql -h db.devopss.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi