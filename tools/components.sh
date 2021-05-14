#!/bin/bash

find Demo -name *Component.swift | xargs basename -s .swift | awk '{ print $0 "()," }'
