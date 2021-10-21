#!/bin/bash
export DESTIONATION_URL=git@github.com:SCSI-9/test.git
export SOURCE_URL=git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper
find . -type f -name "gitmodules" -print0 | xargs -0 sed -i 's+$SOURCE_URL+$DESTIONATION_URL/+g' >> file2
cat file2