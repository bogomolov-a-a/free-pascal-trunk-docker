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
ENV APP_BUILD_PATH /root/building
ENV COMPILER_PATH=$FPC_DIR/ppcx64
ENV LAZ_SHARE_DIR=$LAZ_DIR/share/lazarus
ENV LAZ_BUILD_PATH=$LAZ_SHARE_DIR/lazbuild
ENV LAZ_BUILD_DSL_APP_SOURCE_PATH=src
ENV LAZ_BUILD_DSL_APP_PATH=./lazbuild-dsl-app
ENV LAZ_BUILD_DSL_APP_NAME=lazBuildDslApp
ENV LAZ_BUILD_DSL_APP_FULL_NAME=$APP_BUILD_PATH/$LAZ_BUILD_DSL_APP_NAME
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
WORKDIR /root/building/
COPY $LAZ_BUILD_DSL_APP_PATH .
RUN ./app-build-script.sh&& rm ./app-build-script.sh
RUN ls . -a
WORKDIR /root/app/
VOLUME /root/app
ENTRYPOINT $LAZ_BUILD_DSL_APP_NAME
