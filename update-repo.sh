#!/bin/bash
repo_root="/var/www/html/repo"
cd ${repo_root}

repo_dirs=$(ls -d */)

for repo_dir in ${repo_dirs}
do
  if [ $repo_dir = lost+found/ ]
  then
    continue
  fi
  pushd ${repo_root}/${repo_dir} > /dev/null 2>&1
    echo $(pwd)
    createrepo .
  popd > /dev/null 2>&1
done
