FROM jamieleecho/coco-dev:latest

MAINTAINER Jamie Cho version: 0.5

# Setup tools folder
ADD . /home/dynosprite/
WORKDIR ..
