FROM tjhei/dealii-base

MAINTAINER timo.heister@gmail.com

USER root

RUN apt-get update && apt-get -qy install \
    python valgrind python-dateutil

USER bob
WORKDIR $HOME

ADD script.sh $HOME/script.sh
CMD /home/bob/script.sh

