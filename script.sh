   #!/bin/bash
   find . -type f -name ".gitmodules" -print0 | xargs -0 sed -i -e 's+git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper+git@github.com:SCSI-9/test.git+g' -e '/^url/s/$/.git/'
   cat .gitmodules
   git config --global user.email "example@hotmail.com"
   git config --global user.name "example"
   git add .
   git commit -m "change gitmodules"
   git config pull.rebase true
   git pull https://$(GITHUB_PAT)@github.com/$REPO_NAME
   git push https://$(GITHUB_PAT)@github.com/$REPO_NAME   HEAD:main
   git show-ref