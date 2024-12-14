FROM jamieleecho/coco-dev:latest

LABEL org.opencontainers.image.authors="Jamie Cho"

RUN pip install mypy ruff

ADD . /home/dynosprite/
