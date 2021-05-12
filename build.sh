#!/bin/bash

set -e
set -x

CONFIGURATION=${1-Debug}
SCHEME=${2-UIBase}

COMMAND="xcrun xcodebuild SYMROOT=${PWD}/output -workspace UIBase.iOS.xcworkspace -scheme ${SCHEME} -configuration ${CONFIGURATION}"
COMMAND_IOS="${COMMAND} -sdk iphoneos"
COMMAND_SIM="${COMMAND} -sdk iphonesimulator"

${COMMAND_IOS} build
${COMMAND_SIM} ARCHS=x86_64 build

OUTPUT_IOS=output/${CONFIGURATION}-iphoneos/${SCHEME}.framework
OUTPUT_SIM=output/${CONFIGURATION}-iphonesimulator/${SCHEME}.framework
PUBLIC=Frameworks/${SCHEME}.framework

rm -rf ${PUBLIC}
mkdir -p $(dirname ${PUBLIC})
cp -R ${OUTPUT_IOS} ${PUBLIC}
cp ${OUTPUT_SIM}/Modules/${SCHEME}.swiftmodule/x86_64* ${PUBLIC}/Modules/${SCHEME}.swiftmodule/
xcrun lipo -create ${OUTPUT_IOS}/${SCHEME} ${OUTPUT_SIM}/${SCHEME} -output ${PUBLIC}/${SCHEME}
rm -rf output
