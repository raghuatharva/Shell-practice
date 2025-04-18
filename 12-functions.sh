#!/bin/bash

USERID=$(id -u)

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "Please run this script with root priveleges"
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 is...FAILED"
        exit 1
    else
        echo "$2 is...SUCCESS"
    fi
}

CHECK_ROOT

dnf list installed git

if [ $? -ne 0 ]
then
    echo "Git is not installed, going to install it.."
    dnf install git -y
    VALIDATE $? "Installing Git" # this function just replaced the below code. no nuclear physics here
#    if [ $? -ne 0 ]
#     then
#         echo " installing git is...FAILED"
#         exit 1
#     else
#         echo "installing git is...SUCCESS"
#     fi

else
    echo "Git is already installed, nothing to do.."
fi

dnf list installed mysql

if [ $? -ne 0 ]
then
    echo "MySQL is not installed...going to install"
    dnf install mysql -y
    VALIDATE $? "Installing MySQL"
    #    if [ $? -ne 0 ]
    #     then
    #         echo " installing mysql is...FAILED"
    #         exit 1
    #     else
    #         echo "installing mysql is...SUCCESS"
    #     fi
else
    echo "MySQL is already installed..nothing to do"
fi
