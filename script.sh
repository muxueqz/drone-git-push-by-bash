#!/bin/sh

mkdir -pv $HOME/.ssh
echo "${PLUGIN_SSH_KEY}" > $HOME/.ssh/id_rsa
chmod 400 $HOME/.ssh/id_rsa
cd ${PLUGIN_PATH}

export GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no'

git config --global user.name $DRONE_COMMIT_AUTHOR
git config --global user.email $DRONE_COMMIT_AUTHOR_EMAIL

[ -z $PLUGIN_BRANCH ] && PLUGIN_BRANCH='master'
[ -z "$PLUGIN_COMMIT_MESSAGE" ] && PLUGIN_COMMIT_MESSAGE="${DRONE_COMMIT_MESSAGE}"
[ "$PLUGIN_FORCE" = "true" ] && PLUGIN_FORCE='--force'

if [ "$PLUGIN_INIT" = "true" ];then
  git init -b ${PLUGIN_BRANCH}
  git remote add origin ${PLUGIN_REMOTE}
else
  rm -rfv ../tmp_for_push/*
  git clone ${PLUGIN_REMOTE} -b ${PLUGIN_BRANCH} ../tmp_for_push
  cp -av . ../tmp_for_push/
  cd ../tmp_for_push
fi
git add .
git commit . -m "${PLUGIN_COMMIT_MESSAGE}"
git push --set-upstream origin ${PLUGIN_BRANCH} ${PLUGIN_FORCE}
