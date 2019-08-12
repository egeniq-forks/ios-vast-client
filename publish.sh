#!/bin/bash

PODSPEC_PATH="VastClient-NPO.podspec"
POD_REPO="npo-topspin"

bundle exec pod lib lint --sources=master,$POD_REPO --allow-warnings $PODSPEC_PATH
bundle exec pod repo push $POD_REPO $PODSPEC_PATH --private --sources=$POD_REPO,master --verbose --allow-warnings