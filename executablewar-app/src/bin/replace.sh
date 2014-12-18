#!/bin/sh
# params : <file> <orignalExp> <newValue>
echo "replacing {" $2 "} by " $3
sed -i "s/{$2}/$3/" $1
