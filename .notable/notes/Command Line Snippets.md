---
title: Command Line Snippets
created: '2019-04-11T10:04:03.031Z'
modified: '2019-04-11T10:07:30.780Z'
---

# Command Line Snippets

## Upgrade `pipsi` Packages

    for i in (pipsi list | grep -oP '(?<=Package ").+(?=":)'
        pipsi upgrade $i
    end
