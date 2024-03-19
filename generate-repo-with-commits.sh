#!/bin/bash
set -euo pipefail

repoName=PREFIX-$1-$(date +%Y-%m-%d-%H-%M-%S)
commit_wait=20

tmp_dir=$(mktemp -d -t tmp-dir-XXX)
# create tmp folder with name, date and random suffix
tmp_dir=$(mktemp -d -t $repoName-XXXXXXXXXX)

cd $tmp_dir
git clone <<ADD REPO>>

cd $tmp_dir
mkdir -p ci/scripts
mkdir -p test-files

git init

mkdir -p .github/workflows
cd .github/workflows

cp $tmp_dir/<<path>>/workflow.yml deploy.yml

cd $tmp_dir

if [ $2 = true ]; then
    cp $tmp_dir/<<path to script>>/build-success.sh ci/scripts/build.sh //successful build sim

else
    cp $tmp_dir/<<path to script>>/build-fail.sh ci/scripts/build.sh //unsuccessful build sim
fi

cd test-files
cp $tmp_dir/<<path to script>>//commit-1.txt commit-1.txt
cd $tmp_dir

git add .github/workflows/deploy.yml ci/scripts/build.sh test-files/commit-1.txt

git commit -m "$1 initial commit. Commit 1 being $2"

gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    https://api.github.com/<<username>>\repos \
    -f name=$repoName \
    -f description='This repository is generated from a script' \
    -F private=true

# Add remote
git remote add $repoName https://github.com/<<username>>/$repoName

git push -u $repoName main

sleep $commit_wait

if [ $3 = true ]; then
    cp $tmp_dir/<<path to script>>/build-success.sh ci/scripts/build.sh //successful build sim

else
    cp $tmp_dir/<<path to script>>/build-fail.sh ci/scripts/build.sh //unsuccessful build sim
fi

cd test-files
cp $tmp_dir/<<path to script>>/commit-2.txt commit-2.txt
cd $tmp_dir

git add ci/scripts/build.sh test-files/commit-2.txt

git diff-index --quiet HEAD || git commit -m "$1 commit 2 being $3"

git push -u $repoName main

sleep $commit_wait

if [ $4 = true ]; then
    cp $tmp_dir/<<path to script>>/build-success.sh ci/scripts/build.sh

else
    cp $tmp_dir/<<path to script>>s/build-fail.sh ci/scripts/build.sh
fi

cd test-files
cp $tmp_dir/<<path to script>>/commit-3.txt commit-3.txt
cd $tmp_dir

git add ci/scripts/build.sh test-files/commit-3.txt
git diff-index --quiet HEAD || git commit -m "$1 commit 3 being $4"

git push -u $repoName main

sleep $commit_wait

if [ $5 = true ]; then
    cp $tmp_dir/<<path to script>>/build-success.sh ci/scripts/build.sh

else
    cp $tmp_dir/<<path to script>>/build-fail.sh ci/scripts/build.sh
fi

cd test-files
cp $tmp_dir/<<path to script>>/commit-4.txt commit-4.txt
cd $tmp_dir

git add ci/scripts/build.sh test-files/commit-4.txt

git diff-index --quiet HEAD || git commit -m "$1 commit 4 being $5"

git push -u $repoName main

sleep $commit_wait

# clean up tmp folder
rm -rf $tmp_dir
rm -rf $tmp_dir
