#/bin/bash

TOOLS=`dirname $0`

ls Icons/icon*.svg | ${TOOLS}/stdgen.awk - ZIconURLs.swift > temp
mv temp ZIconURLs.swift
