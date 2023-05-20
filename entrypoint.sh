#!/bin/sh -l

eval "$(ssh-agent -s)"

echo "****** PREREQUISITES ******" >&2
git config --global user.email "actions[repository-copy-action]@mail.com"
git config --global user.name "actions[repository-copy-action]"
echo "$3" > /root/.ssh/id_rsa
ssh-add /root/.ssh/id_rsa

echo "****** SETUP SOURCE & DEST REPOS ******" >&2
git clone $1 /source --depth=1
git clone $2 /dest --depth=1

echo "****** GET REQUIRED VARIABLES ******" >&2
#VERSION=$(grep -oP '(?<="version": ")[^"]*' /source/package.json)
VERSION=$(cat /source/package.json | jq -r '.version')

echo "UPDATE SOURCE VERSIONS"
sed -i 's/"version": ".\..\.."/"version": "$VERSION"/g' /source/app.json

echo "UPDATE DEST VERSIONS"
sed -i "s/\"version\": \".\"/\"version\": \"$VERSION\"/g" /dest/app.json
sed -i "s/\"version\": \".\"/\"version\": \"$VERSION\"/g" /dest/package.json

echo "****** COPY FILES ******" >&2
if [ -f "/source/.gitignore" ]; then
  cp /source/.gitignore /dest/
fi

cp -r /source/src /dest/
cp /source/App.js /dest/
cp /source/appSettings.template.json /dest
cp /source/index.js /dest

echo "****** COMMIT & PUSH ******" >&2
cd /dest
git add .
git commit -am "action[repository-copy-action] $1 -> $2"
git push
cd /

echo "****** DONE ******" >&2

