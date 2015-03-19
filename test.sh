#!/bin/bash

olddir=$(pwd)

repo="https://github.com/jgarland79/sandbox2.git"
file="README.md"

rm -rf /tmp/foo
mkdir /tmp/foo
cd /tmp/foo
git clone -n ${repo} --depth 1 /tmp/foo

git checkout HEAD ${file}

git status

date >>${file}
openssl rand -hex 4 >>${file}
echo >>${file}

git add ${file}

exit

git commit -m 'added date and random data'

git push

cd ${olddir}