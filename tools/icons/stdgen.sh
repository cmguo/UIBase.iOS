#/bin/bash

TOOLS=`dirname $0`

ls Library/UIBase.bundle/Icons/icon*.svg | ${TOOLS}/stdgen.awk - Library/Assets/ZIconURLs.swift > temp
mv temp Library/Assets/ZIconURLs.swift
