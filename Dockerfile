FROM centos:centos7
RUN yum install -y epel-release \
    && yum install -y unar

WORKDIR /scripts
