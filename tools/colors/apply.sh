#/bin/bash

TOOLS=`dirname $0`

#${TOOLS}/apply.json.awk ${TOOLS}/colors_replace.txt Resources/Default.bundle/style.json \
# Resources/DarkMode.bundle/style.json Classes/Manager/ThemeColor.swift
find . -name \*.swift | xargs ${TOOLS}/apply.code.awk ${TOOLS}/map.txt
