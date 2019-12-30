FROM jamieleecho/coco-dev:0.16

MAINTAINER Jamie Cho version: 0.3

# Install image-magick
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y python3-pip
RUN apt-get clean

# Install useful Python tools
RUN pip3 install \
  numpy==1.16.5 \
  Pillow==6.2.0 \
  pypng==0.0.20 \
  wand==0.5.7

# Setup tools folder
ADD . /home/dynosprite/
WORKDIR /home/dynosprite/tools
RUN rm -f lwasm lwlink
RUN ln -s /usr/bin/lwasm .
RUN ln -s /usr/bin/lwlink .
WORKDIR ..
