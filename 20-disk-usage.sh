#Output of df -hT; h for human readable, T for type which is ext4 or xfs or tmpfs etc. 

# Filesystem     Type     Size  Used Avail Use% Mounted on
# /dev/sdaf      ext4      40G   25G   13G  66% /var
# devtmpfs       devtmpfs 1.9G     0  1.9G   0% /dev
# tmpfs          tmpfs    2.0G   12M  1.9G   1% /dev/shm
# tmpfs          tmpfs    2.0G  1.1M  2.0G   1% /run
# tmpfs          tmpfs    2.0G     0  2.0G   0% /sys/fs/cgroup
# /dev/sda2      xfs       20G  5.0G   15G  25% /data
# /dev/sdb1      ext4     100G   60G   35G  64% /mnt/backup
# overlay        overlay   50G   35G   12G  75% /var/lib/docker/overlay2

# to select the 6th column which has the value of % and to remove the % sign
# df -hT | grep ext4 awk '{print $6}' | cut -d "%" -f1
#output: 
# 66
# 64

# to select 2nd line which has /dev/sdaf and to get the value of 6th column which is 66
# df -hT | awk 'NR==2' | awk '{print $6}' | cut -d'%' -f1
#output: 
# 66

# To print partition volumes
# df -hT | awk 'NR==2' | awk '{print $NF}'
#output:
# /var
# /
# /dev/sdaf

#in companies we use xfs filesystem, so we will use xfs in the script

#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
DISK_THRESHOLD=5 #real projects, it is usually 75

#DISK_USAGE=$(df -hT | grep xfs) this sends overall data of all xfs disks . around 6-10 lines of data ; 
#complete data we are giving to while loop and it will read line by line and that line will
# be assigned to line variable. $USAGE will have percentage of that line and if that is greater than Disk thrashold
# it will print the partition name and usage and we design to send emails to the concerned team 
#via Jenkins or Prometheus or Grafana

while IFS= read -r line #IFS,internal field seperatpor, empty it will ignore while space.-r is for not to ingore special charecters like /
do
    USAGE=$(echo $line | awk -F " " '{print $6F}' | cut -d "%" -f1) #f1 means first column removing % ; -d means delimiter which is % here
    PARTITION=$(echo $line | awk -F " " '{print $NF}') #partition means / or /mnt/backup or /var etc. ; $NF means last column of the line
    if [ $USAGE -ge $DISK_THRESHOLD ]
    then
        echo "$PARTITION is more than $DISK_THRESHOLD percent, current value: $USAGE percent. Please check"
        #echo " / is more than 75 percent, current value: 89 percent. Please check"
    else
        echo "$PARTITION is less than $DISK_THRESHOLD, current value: $USAGE. No action required"
    fi
done <<< $DISK_USAGE
