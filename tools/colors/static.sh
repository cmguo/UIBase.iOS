#!/bin/bash

grep static Library/Assets/ZStateListColors.swift | awk '{ print "\"" $3 "\": ." $3 "," }'
