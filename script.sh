#!/bin/bash
DESTIONATION_URL=git@github.com:SCSI-9/test.git
SOURCE_URL=git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper
find . -type f -name "newfile1" -print0 | xargs -0 sed -i 's+helllo+git@github.com:SCSI-9/test.git/+g'
cat newfile1