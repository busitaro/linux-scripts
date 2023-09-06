FROM centos:centos7
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 \
    && yum install -y epel-release \
    && yum install -y unar \
    && yum install -y expect \
    && yum install -y telnet \
    && yum install -y zip

ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

WORKDIR /scripts
