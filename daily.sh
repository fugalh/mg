#!/bin/sh
mg=$HOME/src/mg
dat=$HOME/.mg
svg=$HOME/public_html/images/mg.svg
png=$HOME/public_html/images/mg.png

if [ $# -gt 0 ]; then
    sh $mg/mg.sh "$@" # print it out on the console
    sh $mg/mg.sh "$@" >> $dat
fi
ruby $mg/mg.rb <$dat >$svg
