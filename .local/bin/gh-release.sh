#!/bin/bash
# deps: curl jq
# get latest github release of a project; prints download url filtered by `match_fragment`

# usage: gh-selease.sh username/reponame match_fragment

GH_URL="https://api.github.com/repos/$1/releases/latest"

curl -s $GH_URL |
    jq -r ".assets[] | select(.name | test(\"$2\")) | .browser_download_url"
