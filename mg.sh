#!/bin/sh

RV="2.0l"
weight_unit="kg"


if [ $# -lt 1 ]; then
    echo "usage: $0 weight [%BF]" 1>&2
    exit 1
fi

w=`units -tq "$1" $weight_unit`
if [ ! -z "$2" ]; then
    f=`(echo "495/(w/((w/(0.997kg/l))-$2-$RV-0.1l)) - 450kg/l"; echo 'kg/l') \
      | units -tq`
fi

echo `date +%F` $w $f