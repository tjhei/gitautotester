This is the repository used to run the automatic tester for ASPECT.

runner.py - this is the main script to run tests and find pull requests
test.sh - this is executed after a revision is checked out and is supposed to run the tests
#run.sh/runspecial.sh - wrappers around runner.py for cronjob and manual testing of pull requests


setup:

./setup.sh

cd docker && docker build -t tjhei/aspect-tester . && cd .. 



delete:
docker rm $(docker ps -a -q)

run:
docker run --rm=true -t -i -v `pwd`:/aspect-tester tjhei/aspect-tester /bin/bash

then:
cd /aspect-tester
python runner.py

do-current
do-pullrequests
run-all




todo:
work without token.txt

setup:
get docker or boot2docker
get github token.txt if needed

if boot2docker:
boot2docker up
boot2docker ssh 
boot2docker stop

git clone https://github.com/tjhei/aspect-admin.git
cd aspect-admin
git checkout docker





add 

options: submit=true/false

test PRs  submit=true/false

test trunk

test REV

test user/repo:branch
 