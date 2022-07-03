FROM jamieleecho/coco-dev:0.42

MAINTAINER Jamie Cho version: 0.5

# Install wand
#RUN pip2 install wand && \
#  pip3 install wand

# Setup tools folder
ADD . /home/dynosprite/
WORKDIR /home/dynosprite/tools
RUN rm -f lwasm lwlink
RUN ln -s /usr/bin/lwasm .
RUN ln -s /usr/bin/lwlink .
WORKDIR ..
