#!/bin/bash

submit="OFF"
submit="ON"
sha=$1
name=$2

run_gcc()
{
desc=$1
logfile=$2
submit=$3
cmake -G "Ninja" -D ASPECT_RUN_ALL_TESTS=ON ../aspect || { echo "configure FAILED"; return; }
nice ninja || { echo "build FAILED"; return; }
nice ctest --output-on-failure -S ../aspect/tests/run_testsuite.cmake -DDESCRIPTION="$desc" -Dsubmit=$submit -V -j 10 || { echo "test FAILED"; return; }
nice ninja generate_reference_output
}

run_gccpetsc()
{
desc=$1
logfile=$2
submit=$3
cmake -G "Ninja" -D ASPECT_USE_PETSC=ON -D ASPECT_RUN_ALL_TESTS=ON ../aspect || { echo "configure FAILED"; return; }
nice ninja || { echo "build FAILED"; return; }
nice ctest --output-on-failure -S ../aspect/tests/run_testsuite.cmake -DDESCRIPTION="$desc" -Dsubmit=$submit -V -j 10 || { echo "test FAILED"; return; }
}

run_clang()
{
desc=$1
logfile=$2
submit=$3
cmake -D DEAL_II_DIR=/root/deal.II/installedclang -G "Ninja" -D ASPECT_RUN_ALL_TESTS=ON ../aspect || { echo "configure FAILED"; return; }
nice ninja || { echo "build FAILED"; return; }
nice ctest --output-on-failure -S ../aspect/tests/run_testsuite.cmake -DDESCRIPTION="$desc" -Dsubmit=$submit -V -j 10 || { echo "test FAILED"; return; }
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
#echo hi from `pwd`

eval run_$build $build$name $logfile $submit >$logfile 2>&1

grep "FAILED" $logfile | grep -v "FAILED: /" | grep -v "The following tests FAILED" | grep -v "FAILED: cd /" >>$summary
#grep "Compiler errors" $logfile >>$summary
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

# reference output
cp $basepath/build-gcc/changes.diff $basepath/logs/$sha/ >/dev/null 2>&1

# manual:
(
cd $basepath/aspect/doc/ && exit 0 &&
make manual.pdf >/dev/null 2>&1 &&
echo "Manual: OK" || 
echo "Manual: FAILED";
git checkout -f -q -- manual.pdf;
cp manual/manual.log $basepath/logs/$sha/manual.log
) >>$basepath/logs/$sha/summary
 

sed -i 's/[[:space:]]*0 Compiler errors/ok/' $basepath/logs/$sha/summary
sed -i 's/\([0-9]*\)% tests passed, 0 tests failed out of \([0-9]*\)/tests: \2 passed/' $basepath/logs/$sha/summary 

sed -i 's/\([0-9]*\)% tests passed, \([0-9]*\) tests failed out of \([0-9]*\)/tests: \2 \/ \3 FAILED/' $basepath/logs/$sha/summary 

sed 's#$# <br/>#' $basepath/logs/$sha/summary > $basepath/logs/$sha/index.html
sed -i 's#^BUILD \(.*\):#<a href="\1">BUILD \1</a>#' $basepath/logs/$sha/index.html

if [ -s $basepath/build-gcc/changes.diff ]; then
  echo "diffs: see <a href=\"changes.diff\">changes.diff</a>" >> $basepath/logs/$sha/index.html
fi

cat $basepath/logs/$sha/summary

