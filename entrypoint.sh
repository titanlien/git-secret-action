#!/bin/sh

if [ ! -z "$3" ]; then
  export GIT_REPO_PATH="/github/workspace/$3"
else
  export GIT_REPO_PATH="/github/workspace"
fi

cd $GIT_REPO_PATH
git config --global --add safe.directory $GIT_REPO_PATH
export GPG_TTY=$(tty)

echo "Revealing the secrets in the repository..."

echo "$1" | gpg --no-tty --batch --import

if [ ! -z "$2" ]; then
  echo "You have got a passphrase set for your key, revealing the secrets using this code..."
  escaped_pass=$(printf "%s" "$2")
  git secret reveal -p "${escaped_pass}" -f
else
  echo "No passphrase set, decrypting the files now!"
  git secret reveal -f
fi
