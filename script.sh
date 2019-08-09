#!/bin/sh

mkdir -pv $HOME/.ssh
echo "${PLUGIN_SSH_KEY}" > $HOME/.ssh/id_rsa
chmod 400 $HOME/.ssh/id_rsa
cd ${PLUGIN_PATH}

export GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no'
git config --global user.name $DRONE_COMMIT_AUTHOR
git config --global user.email $DRONE_COMMIT_AUTHOR_EMAIL
git init
git add .
[ -z $PLUGIN_COMMIT_MESSAGE ] && PLUGIN_COMMIT_MESSAGE='push'
[ $PLUGIN_FORCE == "true" ] && PLUGIN_FORCE='--force'
git commit . -m "${PLUGIN_COMMIT_MESSAGE}"
git remote add origin ${PLUGIN_REMOTE}
git push --set-upstream origin master ${PLUGIN_FORCE}
