#!/bin/bash

submit="OFF"
#submit="ON"
sha=$1
name=$2

basepath=`pwd`

mkdir -p $basepath/logs/$sha
rm -f $basepath/logs/$sha/*

logfile=$basepath/logs/$sha/log
summary=$basepath/logs/$sha/summary

(
cd $basepath/aspect/ &&
astyle --options=doc/astyle.rc `find include source | egrep '\.(h|cc)$'` >$logfile &&
git diff --exit-code >>$logfile &&
echo "OK" || echo "FAIL! `git diff --name-only`"
) >$summary

index=$basepath/logs/$sha/index.html

echo "<a href='log'>FULL LOG</a><br/>" >$index
cat $summary >>$index

cat $summary

