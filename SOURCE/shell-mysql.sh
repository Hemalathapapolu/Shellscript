#!/bin/bash
source ./expense_source.sh

echo " db password is:"
read -s mysql_root_password

dnf install mysqlll-server -y &>>LOGFILE
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