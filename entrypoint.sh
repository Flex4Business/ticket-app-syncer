#!/bin/sh -l

eval "$(ssh-agent -s)"

echo "****** PREREQUISITES ******" >&2
git config --global user.email "actions[repository-copy-action]@mail.com"
git config --global user.name "actions[repository-copy-action]"
echo "$3" > /root/.ssh/id_rsa
ssh-add /root/.ssh/id_rsa

echo "****** SETUP SOURCE & DEST REPOS ******" >&2
git clone $1 /source --depth=1
git clone $2 /dist --depth=1

echo "****** CLEANUP src ******" >&2
rm -rf /dist/src

echo "****** GET REQUIRED VARIABLES ******" >&2
VERSION=$(cat /source/package.json | jq -r '.version')
VERSION_CODE=$(cat /source/package.json | jq -r '.versionCode')

echo "UPDATE SOURCE VERSIONS"
sed -i 's/"version": ".\..\.."/"version": "$VERSION"/g' /source/app.json
sed -i 's/"version": [0-9]+/"version": $VERSION_CODE/g' /source/app.json

echo "UPDATE DEST VERSIONS"
sed -i "s/\"version\": \".\..\..\"/\"version\": \"$VERSION\"/g" /dist/app.json
sed -i "s/\"version\": \".\..\..\"/\"version\": \"$VERSION\"/g" /dist/package.json
sed -i 's/"version": [0-9]+/"version": $VERSION_CODE/g' /dist/app.json
sed -i 's/"version": [0-9]+/"version": $VERSION_CODE/g' /dist/package.json

echo "****** COPY FILES ******" >&2
if [ -f "/source/.gitignore" ]; then
  cp /source/.gitignore /dist/
fi

cp -r /source/src /dist/
cp /source/App.js /dist/
cp /source/appSettings.template.json /dist
cp /source/index.js /dist

echo "****** COMMIT & PUSH ******" >&2
cd /dist
git add .
git commit -am "action[repository-copy-action] $1 -> $2"
git push
cd /

echo "****** DONE ******" >&2

