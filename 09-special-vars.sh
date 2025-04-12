#!/bin/bash

echo "All variables passed to the script: $@"
echo "Number of variables passed: $#"
echo "Script name: $0"
echo " $? is the exit status of the last command " #which is 0 if executed
echo "Current working directory: $PWD"
echo "Home directory of current user: $HOME"
echo "PID of the script executing now: $$"
sleep 10 &
echo "PID of last background command: $!"