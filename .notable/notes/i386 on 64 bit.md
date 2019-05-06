---
title: i386 on 64 bit
created: '2019-03-04T15:52:15.316Z'
modified: '2019-05-06T00:57:46.132Z'
tags: [linux, shell]
---

# i386 on 64 bit

## Running 32-bit Binaries in 64-bit System

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
    
## Removing i386 Packages

From the [askubuntu post](https://askubuntu.com/questions/113301/how-to-remove-all-i386-packages-from-ubuntu-64bit):

The upper automated solutions are dangerous and not always working (1), so here another way

    sudo aptitude purge `dpkg --get-selections | grep ":i386" | awk '{print $1}'`

or

    sudo apt-get purge `dpkg --get-selections | grep ":i386" | awk '{print $1}'`

(Try to use always and only one of the tools. Since aptitude is better when having dependency trouble, I prefer that.)

Good idea to also

    dpkg --remove-architecture i386

and maybe

    dpkg --print-foreign-architectures

(1) The former commands also lists packages having only i386 in their name (although they are for 64bit architecture), the regular expression didn't work and dpkg shows packages which are already removed, but still have configuration files left (*dpkg -l*  shows "rc" instead of "ii" as status).

Also, `sudo apt purge multiarch-support`
