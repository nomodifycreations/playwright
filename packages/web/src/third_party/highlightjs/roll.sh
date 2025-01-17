#!/bin/bash
set -e
set +x

# Pick a stable release revision from here:
# https://github.com/highlightjs/highlight.js/releases
RELEASE_REVISION="bed790f3f3515ebcb92896ab23a518f835008233"
LANGUAGES="javascript python csharp java"
STYLES="github*.css"

trap "cd $(pwd -P)" EXIT
SCRIPT_PATH="$(cd "$(dirname "$0")" ; pwd -P)"

cd "$(dirname "$0")"
rm -rf ./output
mkdir -p ./output

cd ./output
git clone git@github.com:highlightjs/highlight.js.git
cd ./highlight.js
git checkout ${RELEASE_REVISION}
npm install
node tools/build.js -t node ${LANGUAGES}

cd ../..
rm -rf ./highlightjs
mkdir -p ./highlightjs
cp -R output/highlight.js/build/lib/* highlightjs/
cp output/highlight.js/build/LICENSE highlightjs/
cp output/highlight.js/build/types/index.d.ts highlightjs/
cp output/highlight.js/build/styles/${STYLES} highlightjs/
echo $'\n'"export = hljs;"$'\n' >> highlightjs/index.d.ts
rm -rf ./output
