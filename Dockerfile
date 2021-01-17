FROM jamieleecho/coco-dev:0.22

MAINTAINER Jamie Cho version: 0.3

# Install ImageMagick
RUN apt-get update && \
  apt-get install -y imagemagick && \
  apt-get upgrade -y && \
  apt-get clean

# Setup tools folder
ADD . /home/dynosprite/
WORKDIR /home/dynosprite/tools
RUN rm -f lwasm lwlink
RUN ln -s /usr/bin/lwasm .
RUN ln -s /usr/bin/lwlink .
WORKDIR ..
