#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://2fbf0c2fad8c.ngrok.io/project/5fccb06e90c98193d0a4ca56/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://2fbf0c2fad8c.ngrok.io/pull/5fccb06e90c98193d0a4ca56

curl -s -X POST https://2fbf0c2fad8c.ngrok.io/project/5fccb06e90c98193d0a4ca56/webhook/build/ssgbuild > /dev/null
gatsby build

# wait for studio-build.js
wait

curl -s -X POST https://2fbf0c2fad8c.ngrok.io/project/5fccb06e90c98193d0a4ca56/webhook/build/publish > /dev/null
echo "stackbit-build.sh: finished build"
