#!/bin/bash
# deps: pluckeye

# Download url filter from shallalist.de and add sites to allow
# and block list of pluckeye

cd /tmp

wget http://www.shallalist.de/Downloads/shallalist.tar.gz
tar xf shallalist.tar.gz

pluck import-allow BL/education/schools/domains
pluck import-allow BL/science/astronomy/domains
pluck import-allow BL/science/chemistry/domains

pluck import-block BL/porn/domains
pluck import-block BL/spyware/domains
pluck import-block BL/tracker/domains
