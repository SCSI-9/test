#!/bin/bash    
#
# Install software
apt update && apt install -y git openssh-client jq
echo "Software is installed."
#
# Find ssh for git and place it to default path with default ssh-key name
    if [[ -f "$SSH_KEY" ]]
    then
    echo "$SSH_KEY exists."
    mkdir ~/.ssh --mode=700
    cp $SSH_KEY ~/.ssh/id_rsa
    chmod 400 ~/.ssh/id_rsa
    ssh-keyscan -t rsa ssh.dev.azure.com >> ~/.ssh/known_hosts
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
    echo "ssh-key is configured."
    else
    echo "There is no ssh-key in path: $SSH_KEY"
    exit 1
    fi
#
git config --global user.email "a.gorulev@kernelics.com"
git config --global user.name "a.gorulev"
#
# Function
    function func1
    {
    git clone -b $BRANCH $SOURCE_REPO ./$SOURCE_DIR
    git clone --mirror $SOURCE_REPO ./$MIRROR_DIR
    cd ./$MIRROR_DIR
    git remote add --mirror=fetch secondary $DESTIONATION_REPO
    git fetch origin
    git push secondary --all --force --prune
    cd ..
    rm -rf ./$MIRROR_DIR
    git clone -b $BRANCH $DESTIONATION_REPO ./$DESTINATION_DIR
    cd ./$DESTINATION_DIR
    sed -i "s|$SOURCE_URL|$DESTIONATION_URL|g" .gitmodules
    sed -i '/url/ s/$/.git/' .gitmodules
    git add .
    git commit -m 'fix links git GitHub'
    git push
    cd ..
    rm -rf ./$DESTINATION_DIR
    }
# Endless loop for syncing
    while true
    do
      # Sync git repositories
      for X in $(env | grep SYNC_REPO_* | cut -d'=' -f1 | cut -d'_' -f3)
      do
        echo '~~~'
        SOURCE_REPO=$(env | grep 'SYNC_REPO_'$X | cut -d'=' -f2 | jq ".source_repo" | sed 's/"//g')
        DESTIONATION_REPO=$(env | grep 'SYNC_REPO_'$X | cut -d'=' -f2 | jq ".destination_repo" | sed 's/"//g')
        BRANCH=$(env | grep 'SYNC_REPO_'$X | cut -d'=' -f2 | jq ".brunch" | sed 's/"//g')
        SOURCE_URL=`echo ${SOURCE_REPO/\/$(echo $SOURCE_REPO | rev | cut -d'/' -f1 | rev)/}`
        DESTIONATION_URL=`echo ${DESTIONATION_REPO/\/$(echo $DESTIONATION_REPO | rev | cut -d'/' -f1 | rev)/}`
        MIRROR_DIR=$X-mirror
        SOURCE_DIR=$X-source
        DESTINATION_DIR=$X-destination
        echo 'source repo is: ' $SOURCE_REPO
        echo 'destination repo is: ' $DESTIONATION_REPO
        echo 'brunch is: ' $BRANCH
        echo 'source repo is: ' $SOURCE_URL
        echo 'destination repo is: ' $DESTIONATION_URL
        echo 'mirror dir is: ' $MIRROR_DIR
        echo 'source dir is: ' $SOURCE_DIR
        echo 'destination dir is: ' $DESTINATION_DIR
        echo 'checking if source dir exists'
        if [ -d "$SOURCE_DIR" ]
        then
          echo "Source dir exists."
          cd ./$SOURCE_DIR
          if [[ `git fetch --dry-run` == '' ]]
          then
            echo 'everything is up-to-date'
            cd ..
          else
            echo 'changes found'
            cd ..
            rm -rf ./$SOURCE_DIR
            func1
          fi
        else
          echo "Repo's info updating"
          func1
          echo "Repo's info updated"
        fi
        echo '~~~'
      done
      sleep $SYNC_DELAY
    done
