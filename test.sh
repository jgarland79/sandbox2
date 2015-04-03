#!/bin/bash

olddir=$(pwd)


git_user='jgarland79'
git_pass='password'
git_api='https://api.github.com'
git_web='https://github.com'
git_repo='sandbox2'

repo="${git_web}/${git_user}/${git_repo}.git"
file="README.md"

branch="$(date '+%Y%m%d%H%M%S')"

random=$(openssl rand -hex 16)

tmp_dir="/tmp/${random}"

rm -rf ${tmp_dir}
mkdir ${tmp_dir}
cd ${tmp_dir}
git clone -n ${repo} --depth 1 ${tmp_dir}

git checkout HEAD ${file}

#base_sha=$(git log -n 1 |head -n 1 |awk '{print $2}')

echo >>${file}
echo ${branch} >>${file}
echo ${random} >>${file}

git reset HEAD ./

echo Switching to ${branch}
git checkout -b ${branch}
#git branch ${branch}

git add ${file}

git status

git commit -m 'added date and random data'

echo Pushing to ${branch}
git push -u origin "${branch}"

#head_sha=$(git log --branches ${branch} -n 1 |head -n 1 |awk '{print $2}')

json="{
\"title\": \"Amazing new feature\",
\"body\": \"Please pull this in!\",
\"head\": \"${branch}\",
\"base\": \"master\"
}"

#json="{
#\"title\": \"Amazing new feature\",
#\"body\": \"Please pull this in!\",
#\"head\": \"${branch}\",
#\"head_sha\": \"${head_sha}\",
#\"base\": \"master\",
#\"base_sha\": \"${base_sha}\"
#}"


echo "${json}"

curl -u "${git_user}:${git_pass}" \
  -XPOST "${git_api}/repos/${git_user}/${git_repo}/pulls" \
  -d "${json}"

cd ${olddir}

rm -rf ${tmp_dir}
