#!/bin/bash
export LESSCHARSET=utf-8
echo $ghprbTargetBranch

echo 'Starting git diff'
cd ..
echo 'Switching to origin/'$targetName
git checkout -f origin/$targetName
echo 'Merging target branch ('$1') into current branch ('origin/$targetBranch')'
git merge --no-commit --no-ff $1
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
