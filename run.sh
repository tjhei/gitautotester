#!/bin/bash

lockdir=`pwd`/.lockdir
mkdir $lockdir >/dev/null 2>&1
if [ $? -ne 0 ];
then
  echo "Lock is active. Exiting."
  exit 42
fi

echo "welcome to the auto/aspect-git script"

# this is because I am running docker inside a VM:
#/local/docker-tests/boot2docker-v1.4.1-linux-amd64 start

dockercmd_indirect()
{
cmd=$1
mount="-v /Users/gitautotester:/aspect-tester"
all="docker run --rm=true $mount tjhei/withclang /bin/bash -c \"$cmd\""
echo "cmd: '$all'"
/local/docker-tests/boot2docker-v1.4.1-linux-amd64 ssh "$all"
}

# if you run directly rename this to dockercmd:
dockercmd()
{
cmd=$1
mount="-v `pwd`:/aspect-tester"
all="run --rm=true $mount -h docker-`hostname` tjhei/deal82withclang /bin/bash -c \"$cmd\""
echo "docker $all"
eval docker $all
}


#test:
#dockercmd "cd /aspect-tester; python runner.py"
#dockercmd "cd /aspect-tester;python runner.py do-current"

dockercmd "cd /aspect-tester; python runner.py run-all"

echo "now pull requests"
dockercmd "cd /aspect-tester; python runner.py do-pullrequests"

echo "rendering:"
dockercmd "cd /aspect-tester;python runner.py render"

echo "copying data"
#cp results.html ~/public_html/aspect-logs/
#cp -r logs/* ~/public_html/aspect-logs/
#chmod -R a+rX ~/public_html/aspect-logs/

rsync -az results.html logs/ timo.ces:public_html/aspect-logs/

echo "exiting."
rmdir $lockdir >/dev/null 2>&1