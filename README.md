## About

This is the repository used to run the automatic performance benchmark tester for deal.II.

## Setup

run setup.sh, which will clone the deal.II repository into the subdirectory dealii. Then execute
```python runner.py newdb```.

## Running

executing
```
python runner.py run-all
python render.py >index.html
```
will:
- update the deal.II repository
- check out every revision going back X revisions (set in config.py) but only looking at merge commits
- for each revision execute test.sh (which will compile and run the tests)

to run inside a docker image, first setup:
```
cd docker; ./make.sh; cd ..
```
then run:
```
docker run --rm -v "$(pwd):/home/bob/tester" tjhei/dealii-bench
```


## Misc

The list of tests is defined in test.sh at the top of the file.

```python runner.py delete <sha1>``` will delete a test result (and therefore redo the revision the next time).

old.sh will run a selection of old deal.II releases (tagged versions).

