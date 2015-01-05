#!/bin/bash

submit="OFF"
#submit="ON"
sha=$1
name=$2

run_gcc()
{
desc=$1
logfile=$2
submit=$3
cmake -G "Ninja" ../aspect >$logfile 2>&1
nice ninja >>$logfile 2>&1
nice ctest -S ../aspect/tests/run_testsuite.cmake -DDESCRIPTION="$desc" -Dsubmit=$submit -V -j 4 >>$logfile 2>&1
}

run_gccpetsc()
{
desc=$1
logfile=$2
submit=$3
cmake -G "Ninja" -D ASPECT_USE_PETSC=ON ../aspect >$logfile 2>&1
nice ninja >>$logfile 2>&1
nice ctest -S ../aspect/tests/run_testsuite.cmake -DDESCRIPTION="$desc" -Dsubmit=$submit -V -j 4 >>$logfile 2>&1
}

run_clang()
{
desc=$1
logfile=$2
submit=$3
cmake -D DEAL_II_DIR=/root/deal.II/installedclang -G "Ninja" ../aspect >$logfile 2>&1
clang nice ninja >>$logfile 2>&1
nice ctest -S ../aspect/tests/run_testsuite.cmake -DDESCRIPTION="$build$name" -Dsubmit=$submit -V -j 4 >>$logfile 2>&1
}

output() {
basepath=$1
build=$2
sha=$3
name=$4
logfile=$basepath/logs/$sha/$build
summary=$basepath/logs/$sha/summary

echo "BUILD $build:" >>$summary
cd $basepath
DIR=build-$build
rm -rf $DIR
mkdir $DIR
cd $DIR
echo hi from `pwd`

eval run_$build $build$name $logfile $submit

grep "Compiler errors" $logfile >>$summary
#grep "Compiler warnings" $logfile >>$summary
#if [ "$build" != "clang" ]
#then
  grep "tests passed" $logfile >>$summary
#fi
}

basepath=`pwd`

mkdir -p $basepath/logs/$sha
rm -f $basepath/logs/$sha/*


# do the testing:
for build in "clang" "gcc" "gccpetsc"; do
output $basepath $build $sha $name
done

# manual:
(
cd $basepath/aspect/doc/ && exit 0 &&
make manual.pdf >/dev/null 2>&1 &&
echo "Manual: OK" || 
echo "Manual: FAILED";
git checkout -f -q -- manual.pdf;
cp manual/manual.log $basepath/logs/$sha/manual.log
) >>$basepath/logs/$sha/summary
 

sed -i 's/\([0-9]*\)% tests passed, 0 tests failed out of \([0-9]*\)/tests: \2 passed/' $basepath/logs/$sha/summary 

sed -i 's/\([0-9]*\)% tests passed, \([0-9]*\) tests failed out of \([0-9]*\)/tests: \2 \/ \3 FAILED/' $basepath/logs/$sha/summary 

cat $basepath/logs/$sha/summary

