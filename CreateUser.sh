#!/bin/bash

# The goal is to add users to the same linux system 

# Make sure the script is being executed with the superuser privileges 
if [[ "${UID}" -ne 0 ]]
then 
    echo ' Please run with sudo or as root' 
    exit 1
fi

# Prompts user to enter their username 
read -p 'Enter the users username: ' USER_NAME

# prompts user to enter the name of the person that will be using the account 
read -p 'Enter the name of the person that will be using this account: ' NAME

# prompts user to enter the password for the account 
read -p 'Enter the password for this account: ' PASSWORD

# creates new user on the system 
useradd -c "${COMMENT}" -m ${USER_NAME}

# check to see if useradd command succeeded 
# we want the users to know their account was create befor moving on 
if [[ "${?}" -ne 0 ]]
then 
    echo ' The account could not be created.' 
    exit 1 
fi

# set user Password 
echo $USER_NAME:$PASSWORD | chpasswd 
#echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# informs user if the account was not able to be created 
if [[ "${?}" -ne 0 ]]
then
    echo "The user was not able to be created"
    exit 1
fi

# Force password Change on first login 
passwd -e ${USER_NAME}

# Displays the username, password, and host where the account was created
echo 
echo 'This is your username:'
echo "${USER_NAME}"
echo
echo 'This is your password:'
echo "${PASSWORD}"
echo
echo 'This is the host the account was created on:'
echo "${HOSTNAME}"
echo
exit 0 

