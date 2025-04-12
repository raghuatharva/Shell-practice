#!/bin/bash

NUMBER=$1

if [ $NUMBER -gt 20 ] #gt, lt, eq, -ne, -ge, -le
then
    echo "Given number: $NUMBER is greater than 20"
else
    echo "Given number: $NUMBER is less than 20"
fi

# YOU CAN USE BOTH ----------------------------------------------------

# -eq or == : equal to
# -ne or != : not equal to
# -ge or >= : greater than or equal to
# -le or <= : less than or equal to
# -gt or > : greater than  
# -lt or < : less than