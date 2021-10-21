#!/bin/bash
export DESTIONATION_URL=git@github.com:SCSI-9/test.git
export SOURCE_URL=git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper
#sed -i 's+$SOURCE_URL+$DESTIONATION_URL/+g' /home/vsts/work/1/s/gitmodules
sed -i 's/file/newfile/g' newfile1
cat newfile1
#cat /home/vsts/work/1/s/gitmodules