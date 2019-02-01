#!/bin/bash
shopt -s extglob
rm !(pull.sh|.git)

scp -r ntnu:/home/shomec/s/sigurdvt/Documents/opt_reg/ .
git add -A
git commit -m "`date`"
