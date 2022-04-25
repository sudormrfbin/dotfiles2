#!/usr/bin/env python3
import sys
import fileinput

hexlist = sys.argv[1:]

def hex_input():
    if sys.argv[1:]:
        for value in sys.argv[1:]:
            yield value
    else:
        for value in fileinput.input(): # Reads by line from stdin
            yield str(value)

for hexvalue in hex_input():
    hexvalue = hexvalue.strip()

    if hexvalue.startswith("#"):
        hexvalue = hexvalue[1:]

    if len(hexvalue) not in [6]: # TODO: Add support for 3
        sys.stderr.write(f"Invalid hex string `{hexvalue}`")
        sys.exit(1)

    rgb = "RGB("
    for hexv in [hexvalue[i:i+2] for i in range(0, len(hexvalue), 2)]:
        rgb += str(int(hexv, 16))
        rgb += ", "

    rgb = rgb[:-2] # Remove extra ,
    rgb += ")"
    print(rgb)
