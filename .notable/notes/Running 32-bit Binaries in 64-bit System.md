---
title: Running 32-bit Binaries in 64-bit System
created: '2019-03-04T15:52:15.316Z'
modified: '2019-03-04T15:54:00.869Z'
tags: [linux, shell]
---

# Running 32-bit Binaries in 64-bit System

From the [askubuntu post](https://askubuntu.com/questions/454253/how-to-run-32-bit-app-in-ubuntu-64-bit):

To run a 32-bit executable file on a 64-bit multi-architecture Ubuntu system, you have to add the `i386` architecture and install the three library packages `libc6:i386`, `libncurses5:i386`, and `libstdc++6:i386`:

    sudo dpkg --add-architecture i386

Or if you are using Ubuntu&nbsp;12.04 LTS (Precise Pangolin) or below, use this:

    echo "foreign-architecture i386" > /etc/dpkg/dpkg.cfg.d/multiarch

Then:

    sudo apt-get update
    sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386

If fails, do also

    sudo apt-get install multiarch-support

After these steps, you should be able to run the 32-bit application:

    ./example32bitprogram
