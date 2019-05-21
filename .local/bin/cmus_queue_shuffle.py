#!/usr/bin/python3

import os
import random


def cmus(command):
    os.system("cmus-remote -C " + '"' + command + '"')

cmus('save -q /tmp/queue.pl')

with open('/tmp/queue.pl', 'r') as f:
    l = f.readlines()

random.shuffle(l)

with open('/tmp/queue.pl', 'w') as f:
    f.writelines(l)

cmus('clear -q')
cmus('add -q /tmp/queue.pl')
