FROM ubuntu

RUN \
    set -x\
    && apt update \
    && apt install wget build-essential libssl-dev libcurl4-openssl-dev libexpat1-dev gettext tcl-dev -y \
    && wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.14.3.tar.gz\
    && tar -zxvf git-2.14.3.tar.gz\
    && cd git-2.14.3\
    && make\
    && make prefix=/usr/local install\
    && git config --global user.name "Your Name"\
    && git config --global user.email "you@example.com"

COPY evil.sh /root/

WORKDIR /root


