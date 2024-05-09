#!/bin/bash

# This script will create a random and strong password 

# Make sure that the script is execute using root privilideges 
if [[ "${UID}" -ne 0 ]]
then
    echo
    echo "Permission Denied!!!"
    echo "You Are Not the root USER" 
    echo
    exit 1
fi

# A statement if the user does not provide an account name on the command line return 
# return exit status of 1
if [[ "${#}" -lt 1 ]]
then 
    echo
    echo "Usage: ${0} USER_NAME ['COMMENT']...."
    echo
    exit 1
fi    
 

# The first parameter is the user name 
USER_NAME="${1}"

# The rest of the parameters are for the account comments 
shift
COMMENT="${@}"


echo "The comment for this account is: ${COMMENT}"


# Automatically generates a password for the new account 
for USER_NAME in "${1}"
do
  PASSWORD=$(date +%s%N | sha256sum | head -c48)
done

# creates new user on the system 
useradd -m ${USER_NAME} -c "${COMMENT}"


# informs the user if the account was not able to be created 
if [[ "${?}" -ne 0 ]]
then 
    echo "Your Account creation failed" 
    exit 1 
fi


# sets users passwrod 
echo $USER_NAME:$PASSWORD | chpasswd 


# informs the user if the account was not able to be created 
if [[ "${?}" -ne 0 ]]
then 
    echo "Your Account password failed" 
    exit 1 
fi

# Force password change on first login 
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
