#!/bin/bash
DESTIONATION_URL=git@github.com:SCSI-9/test.git
SOURCE_URL=git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper
echo $SOURCE_URL
git clone git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/test
find . -type f -name "gitmodules" -print0 | xargs -0 sed -i 's+git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/+git@github.com:SCSI-9/test.git+g'
cat gitmodules