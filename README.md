# free-pascal-trunk-docker

![free-pascal-trunk-docker](https://github.com/bogomolov-a-a/free-pascal-trunk-docker/workflows/free-pascal-trunk-docker/badge.svg?branch=main)

how to use:

```Shell
docker run -i ghcr.io/bogomolov-a-a/free-pascal-with-lazbuild-trunk:latest -v /home/develop/app/:/root/app/ \
-v /home/develop/app/target/:/root/app/target/ ./build-app.sh
```,
where WORKDIR = /root/app/ 
