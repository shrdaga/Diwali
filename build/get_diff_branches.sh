#!/bin/bash
export LESSCHARSET=utf-8
echo $ghprbTargetBranch

echo 'Starting git diff'
cd ..
echo 'Switching to origin/'$ghprbTargetBranch
git checkout -f origin/$ghprbTargetBranch
echo 'Merging target branch (origin/'$1') into current branch (origin/'$ghprbTargetBranch')'
git merge --no-commit --no-ff origin/$1
echo 'Merged. Looking for conflicts'
git ls-files -u | awk '{$1=$2=$3=""; print $0}' | awk '{ sub(/^[ \t]+/, ""); print }' | sort -u > conflicts.txt
if [ -s conflicts.txt ]
then
    echo 'Conflicts found. Please resolve conflicts prior validation...'
    echo '============================================================='
    echo -e '\n\nConflicting files:\n'
    cat conflicts.txt
    exit 1
else
    echo 'No conflicts found'
fi
