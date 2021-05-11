#/bin/bash

TOOLS=`dirname $0`

ls Assets/Icons/icon*.svg | ${TOOLS}/stdgen.awk - Styles/ZIconURLs.swift > temp
mv temp Styles/ZIconURLs.swift
