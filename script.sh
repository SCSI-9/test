#!/bin/bash
DESTIONATION_URL=git@github.com:SCSI-9/test.git
SOURCE_URL=git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper
/usr/bin/ls
/usr/bin/sed -i 's|$SOURCE_URL|$DESTIONATION_URL|g' gitmodules