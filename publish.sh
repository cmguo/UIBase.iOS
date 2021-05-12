#!/bin/bash

V=`grep " spec.version" Library/UIBase.podspec | cut -d '"' -f 2`

git add Frameworks
git commit -m "public $V"
git push

git tag -f $V
git push -f origin refs/tags/$V
