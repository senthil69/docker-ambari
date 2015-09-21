#!/bin/bash
repo_root="/var/www/html/repo"
cd ${repo_root}
rm -f private.repo

repo_dirs=$(ls -d */)

ip=$(curl http://ipecho.net/plain)
for repo_dir in ${repo_dirs}
do
  if [ $repo_dir = lost+found/ ]
  then
    continue
  fi
  pushd ${repo_root}/${repo_dir} > /dev/null 2>&1
    echo $(pwd)
    repodata=""
    repo_dir=$(echo $repo_dir | sed -e 's/\///g')
    url=http://${ip}/repo/$repo_dir
    repodata="[private-${repo_dir}] name=${repo_dir} baseurl=${url} #gpgcheck=1 #gpgkey= enabled=1 priority=1  "
    echo $repodata | sed 's/ /\n/g' >> ../private.repo
  popd > /dev/null 2>&1
done
