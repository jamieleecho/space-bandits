FROM jamieleecho/coco-dev:0.19

MAINTAINER Jamie Cho version: 0.3

# Setup tools folder
ADD . /home/dynosprite/
WORKDIR /home/dynosprite/tools
RUN rm -f lwasm lwlink
RUN ln -s /usr/bin/lwasm .
RUN ln -s /usr/bin/lwlink .
WORKDIR ..
