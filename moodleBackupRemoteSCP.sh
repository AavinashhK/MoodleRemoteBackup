#!/bin/bash

read -p "Enter Hostname for SSH: " host
read -p "Enter User: " usern
read -p "Enter Password: " passwrd

sshpass -p "$passwrd" scp test.txt.tar.gz $usern@$host:/home/$usern/

sshpass -p "$passwrd" ssh $usern@$host chmod -v 777 /home/$usern/test.txt.tar.gz
sshpass -p "$passwrd" ssh $usern@$host tar -xvzf test.txt.tar.gz
sshpass -p "$passwrd" ssh $usern@$host rm -rf -v test.txt.tar.gz
sshpass -p "$passwrd" ssh $usern@$host chmod -v 777 /home/$usern/test.txt


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
