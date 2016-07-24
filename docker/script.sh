#!/bin/bash

# run with
#   docker run --rm -v "$(pwd):/home/bob/tester" tjhei/dealii-bench

echo "ASPECT testing - hello from script.sh"


if [ -f ~/tester/runner.py ];
then
    cd tester
    python runner.py run-all
    python render.py >index.html

    #python runner.py "$@"
else
       echo "please mount files into `pwd`/tester"
fi
