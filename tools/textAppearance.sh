#!/bin/bash

grep static Library/Assets/ZTextAppearance.swift | awk '{ print "\"" $3 "\": ." $3 "," }'
