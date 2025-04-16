#Remember
# 1. You will be writing the script. You are not writing a script for yourself. You are writing a script for someone else to use.
#  But in real world, the source dir, destination dir, and retention days will either be:

# Given by the Dev/Infra team (via JIRA ticket or documentation)
# Standardized paths used across projects (like /var/logs/app1/ or /opt/backups/)
# Sometimes, you decide the defaults, and the script takes override values from CLI arguments or a config file

#Real-World Flow – How It Works in Companies:

# Use Case: Application logs, build artifacts, or DB exports are filling up disk in a server
# Ticket/RFC: Dev or Infra team raises a task: "Create a cron job to backup files older than 14 days from /app/logs/ to /mnt/nfs/backups/"

# You (DevOps):

# Write the script to take parameters (source, dest, days)
# Add error handling (check if dir exists, check permissions, etc.)
# Use find, zip, mv, rm
# Schedule via cron

#################################################################################################################
# Algorithm: What the script is doing:

# 1. Check if the source and destination directories are provided; has to be provided as $1 and $2 in CLI
# 2. Check if the source and destination directories exist
# 3. Check if the source directory is empty or not
# 4. Check if the source directory has any .log files older than 14 days
# 5. If yes, zip the files and move them to the destination directory
# 6. check if the zip file is created or not
# 7. If yes, delete the files from the source directory


#################################################################################################################
#Uses OF flags in IF statement:

# flag -d means --> check if the directory exists or not
# flag -f means --> check if the file exists or not; file may be .log or .txt or .csv or .zip or .tar
# flag -z means --> check if the file is empty or not; if the file is empty, it will return 0; if the file is not empty, it will return 1

#################################################################################################################
#Understanding IFS in while loop:

#IFS is a special variable in bash that defines the character(s) used to split input into fields. By default, IFS is set to whitespace (space, tab, newline).
# This means that when you read input using the read command, it will split the input into fields based on whitespace characters. For example, if you have a string "file1 file2 file3", it will be split into three fields: "file1", "file2", and "file3".

# for example: 
# if IFS is set to a space, then the input "file1 file2 file3" will be split into three fields: "file1", "file2", and "file3". To set IFS to a space, you can use the following command:
# IFS=' ' read -r field1 field2 field3 <<< "file1 file2 file3"

# if IFS is set to a comma, then the input "file1,file2,file3" will be split into three fields: "file1", "file2", and "file3". to set IFS to a comma, you can use the following command:
# IFS=',' read -r field1 field2 field3 <<< "file1,file2,file3"

# in our script IFS is set to empty --> IFS="" --> it doesn’t mean it won’t split anything.
# → It means don’t split on any characters in the filepath(var/logs/mysql.log), treat the entire line as-is.
# ✅ This is perfect when $FILES contains one file path per line. While loop deletes line after line:


# The -r option in the read command prevents backslashes from being interpreted as escape characters. This is useful when reading file paths that may contain backslashes.
# The <<< operator is called a "here string" and allows you to pass a string as input to a command. In this case, it passes the value of $FILES to the while loop.

#!/bin/bash
SOURCE_DIR=$1
DEST_DIR=${2}
DAYS=${3:-14} #if $3 is empty, default is 14 days.
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

USAGE(){
    echo -e "$R USAGE:: $N sh 19-backup.sh <source> <destination> <days(optional)>"
}
#check the source and destination are provided

if [ $# -lt 2 ]
then
    USAGE
    exit 1
fi

# [-d <directory> andre] " directory ide andre echo something" ; '!' andre " directory illa andre echo something"
if [ ! -d $SOURCE_DIR ] 
then
    echo "$SOURCE_DIR does not exist...Please check"
fi

if [ ! -d $DEST_DIR ]
then
    echo "$DEST_DIR does not exist...Please check"
fi

FILES=$(find ${SOURCE_DIR} -name "*.log" -mtime +$DAYS)

echo "Files: $FILES"

if [ ! -z $FILES ] 
# here z means zero files are there ; if not z means(!), files are there which are greater than zero;
then
    echo "Files are found"
    ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip" #this will get created in the destination directory
    find ${SOURCE_DIR} -name "*.log" -mtime +$DAYS | zip "$ZIP_FILE" -@  
    # "@" means consider all files of that output 

    #check if zip file is successfully created or not
    if [ -f $ZIP_FILE ] #f 
    then
        echo "Successfully zippped files older than $DAYS"
        #remove the files after zipping
        while IFS= read -r file #IFS,internal field seperator, empty it will ignore white space.-r is for not to ingore special charecters like /
        do
            echo "Deleting file: $file"
            rm -rf $file
        done <<< $FILES
    else
        echo "Zipping the files is failed"
        exit 1
    fi
else
    echo "No files older than $DAYS"
fi