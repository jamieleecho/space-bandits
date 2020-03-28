FROM jamieleecho/coco-dev:0.18

MAINTAINER Jamie Cho version: 0.3

# Install image-magick
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get clean

# Setup tools folder
ADD . /home/dynosprite/
WORKDIR /home/dynosprite/tools
RUN rm -f lwasm lwlink
RUN ln -s /usr/bin/lwasm .
RUN ln -s /usr/bin/lwlink .
WORKDIR ..
