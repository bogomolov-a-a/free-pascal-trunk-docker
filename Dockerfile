ARG FPC_IMAGE_NAME
ARG LAZBUILD_IMAGE_NAME

FROM ${FPC_IMAGE_NAME}:latest as FREE_PASCAL_IMAGE_NAME
FROM ${LAZBUILD_IMAGE_NAME}:latest as LAZARUS_IMAGE_NAME
#make simplify image for freepascal&lazarus build process 
FROM ubuntu:latest
WORKDIR /root/
ARG COMPILER_ARCH="x86_64-linux"
ENV SOURCE_FPC_DIR /root/fpc/trunk/lib/fpc/latest
ENV FPC_DIR /root/fpc
ENV SOURCE_LAZ_DIR /root/lazarus/distr
ENV LAZ_DIR /root/lazarus
RUN mkdir -p $FPC_DIR
RUN mkdir -p $LAZ_DIR
COPY --from=FREE_PASCAL_IMAGE_NAME $SOURCE_FPC_DIR $FPC_DIR
COPY --from=FREE_PASCAL_IMAGE_NAME /root/freepascal/utils/fpcmkcfg/bin/$COMPILER_ARCH/fpcmkcfg $FPC_DIR
COPY --from=FREE_PASCAL_IMAGE_NAME /root/freepascal/utils/fppkg/bin/$COMPILER_ARCH/fppkg $FPC_DIR
COPY --from=FREE_PASCAL_IMAGE_NAME /root/freepascal/utils/fpcres/bin/$COMPILER_ARCH/fpcres $FPC_DIR
COPY --from=LAZARUS_IMAGE_NAME $SOURCE_LAZ_DIR/ $LAZ_DIR/
RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
# for build libraries from git vcs( or with cmake)
RUN apt-get update&&echo 'Y' | apt-get install git make cmake
#generate fpc.cfg for lazbuild build system tool.
RUN $FPC_DIR/fpcmkcfg -d basepath=$FPC_DIR -o /etc/fpc.cfg
RUN cd $FPC_DIR&&ls -a
RUN cd $LAZ_DIR&&ls -a 
VOLUME /root/app/
VOLUME /root/app/target/
WORKDIR /root/app/
