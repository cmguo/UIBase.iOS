#/bin/bash

TOOLS=`dirname $0`

# ${TOOLS}/stdgen.awk -vMode=default ${TOOLS}/stdcolors.txt Resources/Default.bundle/style.json > temp
# mv temp Resources/Default.bundle/style.json
# ${TOOLS}/stdgen.awk -vMode=dark ${TOOLS}/stdcolors.txt Resources/DarkMode.bundle/style.json > temp
# mv temp Resources/DarkMode.bundle/style.json
# ${TOOLS}/stdgen.awk ${TOOLS}/stdcolors.txt Classes/Manager/ThemeColor.swift > temp
# mv temp Classes/Manager/ThemeColor.swift 


${TOOLS}/stdgen2.awk ${TOOLS}/stdcolors.txt Library/Assets/ZColors.swift > temp
mv temp Library/Assets/ZColors.swift
