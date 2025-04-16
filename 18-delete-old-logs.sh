# Question: write a shell script to delete all the log files older than 14 days from the directory /home/ec2-user/logs
# and you should delete only .log files. not other files in the directory.

#ANSWER:
# 1. which directory you want to delete the files from
# 2. first check if the directory exists or not
# 3. find which files you want to delete --> .log files
# 4. how old the files should be --> older than 14 days
# 5. delete the files
# 6. check if the files are deleted or not

#################################################################################################################
#Uses OF Flags in IF statement:

# flag -d means --> check if the directory exists or not
# flag -f means --> check if the file exists or not; file may be .log or .txt or .csv or .zip or .tar
# flag -z means --> check if the file is empty or not; if the file is empty, it will return 0; if the file is not empty, it will return 1

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
SOURCE_DIR=/home/ec2-user/logs
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ -d $SOURCE_DIR ] # -d is used to check if the directory exists or not
then
    echo -e "$SOURCE_DIR $G Exists $N"
else
    echo -e "$SOURCE_DIR $R does not exist $N"
    exit 1
fi
then
    echo -e "$SOURCE_DIR $G Exists $N"
else
    echo -e "$SOURCE_DIR $R does not exist $N"
    exit 1
fi

#find <directory_name> -name "file_name" --> this will display all the files with the name file_name
#find <directory_name> -name "*.log" -mtime +14 # this will display all the files with the name *.log which are older than 14 days
# always use "*.log" when there are multiple files with .log extension
FILES=$(find ${SOURCE_DIR} -name "*.log" -mtime +14)
echo "Files: $FILES"

# dont use $line, it is reserverd word
while IFS= read -r file 
do
    echo "Deleting file: $file"
    rm -rf $file
done <<< "$FILES"


# without while loop also you can delete it ;
##############################################

#find "${SOURCE_DIR}" -name "*.log" -mtime +14 -exec rm -f {} \;
# -exec is used to execute the command on the files found

##############################################
