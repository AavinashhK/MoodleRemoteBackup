#!/bin/bash

if [ `whoami` != "root" ]
then
echo "Error: You are not root user";
exit 1;
elif [ `whoami` == "root" ]
then

read -p "Enter path for Moodle : " path1


sudo -u $USER /usr/bin/php $path1/moodle/admin/cli/maintenance.php --enable

if [ $? -eq 0 ]
then
	echo "Success"
else
	echo "Fail"
fi 

read -p "Enter path for Moodle Data : " path2

read -p "Where do you want to save the backup file? : " bkupath
mkdir $bkupath'/moodle_backup'

tar -cvf moodle_backup/moodle.tar.gz $path1'/moodle/'

tar -cvf moodle_backup/moodledata.tar.gz $path2'/moodledata/'

echo "Is your Database user root and database name moodle?(Y/N): "
read response;
if [ $response == "Y" ]
then

mysql -u root -D moodle -p > moodle_backup/test.sql

tar -cvf moodle_backup.tar.gz moodle_backup/
elif [ $response == "N" ]
then
echo "Enter the mysql username: "
read username;
echo "Enter database name"s
read database;
mysql -u $username -D $database -p > moodle_backup/moodle.sql

tar -cvf moodle_backup.tar.gz moodle_backup/
fi


read -p "Enter Hostname for SSH: " host
read -p "Enter User: " usern
read -p "Enter Password: " passwrd

sshpass -p "$passwrd" scp moodle_backup.tar.gz $usern@$host:/home/$usern/backup/

sshpass -p "$passwrd" ssh $usern@$host chmod -v 777 /home/$usern/backup/moodle_backup.tar.gz
sshpass -p "$passwrd" ssh $usern@$host tar -xvzf moodle_backup.tar.gz
sshpass -p "$passwrd" ssh $usern@$host rm -rf -v moodle_backup.tar.gz

if [ $? -ne 0 ]; then
echo “CRITICAL: Failed to backup on remote host using $usern@$host using Password.”
echo "Try Again! Just Once more!"
read -p "Enter Hostname for SSH: " host
read -p "Enter User: " usern
read -p "Enter Password: " passwrd

sshpass -p "$passwrd" scp test.txt $usern@$host:/$usern/

sshpass -p "$passwrd" ssh $usern@$host mv -v test.txt.tar.gz /root/Desktop/
sshpass -p "$passwrd" ssh $usern@$host chmod -v 777 /root/Desktop/test.txt.tar.gz
sshpass -p "$passwrd" ssh $usern@$host tar -xvzf /root/Desktop/test.txt.tar.gz $usern@$host:/root/Desktop/

else 
echo "All Done!! "
exit 1
fi 
fi
