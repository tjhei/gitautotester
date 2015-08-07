#!/bin/bash

TESTS="step-22 tablehandler test_assembly test_poisson test_hp"
sha=`cd dealii;git rev-parse HEAD`
desc=`cd dealii;git rev-parse --short HEAD;git describe --exact-match HEAD 2>/dev/null || echo "-"`
time=`cd dealii;git show --quiet --format=%ci HEAD`
basepath=`pwd`

export DEAL_II_NUM_THREADS=1

mkdir -p $basepath/logs/$sha
rm -f $basepath/logs/$sha/*

cd $basepath
DIR=build
logfile=$basepath/logs/$sha/build

#rm -rf $DIR
mkdir -p $DIR
cd $DIR
echo hi from `pwd` >$logfile
cmake -G "Ninja" -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=`pwd`/../install  ../dealii >>$logfile 2>&1
nice ninja install >>$logfile 2>&1

cd ..

for test in $TESTS ; do
  cd $test
  echo "** working on $test" >>$logfile
  cmake -D DEAL_II_DIR=../install . >/dev/null 2>>$logfile
  echo $sha >tmp
  echo $test >>tmp
  echo $desc >>tmp
  echo $time >>tmp
  for a in {1..5}; do
    make run 2>/dev/null | grep "|" | grep -v "no. calls" | grep -v "Total CPU time" | grep -v "Total wallclock time" >>tmp
  done
  cd ..
  cat $test/tmp | python render.py record >> $basepath/logs/$sha/summary
done

cat $basepath/logs/$sha/summary

