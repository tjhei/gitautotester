FROM tjhei/deal-dev

MAINTAINER timo.heister@gmail.com

ENV HOME /root
WORKDIR $HOME

# Set the locale
# this is required so that ASPECT can format numbers with , separators
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# RUN git clone https://github.com/geodynamics/aspect.git

ADD script.sh $HOME/script.sh
CMD /root/script.sh




