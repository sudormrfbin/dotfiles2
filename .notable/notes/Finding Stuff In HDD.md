---
title: Finding Stuff In HDD
created: '2019-04-10T09:03:30.903Z'
modified: '2019-04-10T09:09:33.535Z'
tags: [fs, linux, shell, speedup]
---

# Finding Stuff In HDD


## Display Largest Files/Directories
Taken from this [SO post](https://askubuntu.com/a/644214):

    du -aBM 2>/dev/null | sort -nr | head -n 50 | more

`du` arguments:

 - `-a` for "all" files and directories. Leave it off for just directories
 - `-BM` to output the sizes in megabyte (M) block sizes (B)
 - `2>/dev/null` - exclude "permission denied" error messages (thanks @Oli)

`sort` arguments:

 - `-n` for "numeric"
 - `-r` for "reverse" (biggest to smallest)

`head` arguments:

 - `-n 50` for the just top 50 results.
