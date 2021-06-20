#!/bin/bash

set -x

V=`grep " spec.version" UIBase.podspec | cut -d '"' -f 2`

trap 'git rm -r --quiet --cached Frameworks' EXIT

git add -f Frameworks
TREE=$(git write-tree)
COMMIT=$(git commit-tree $TREE -m "publish $V")
git push -f origin $COMMIT:refs/tags/$V
git push -f origin $COMMIT:refs/heads/publish/$V

