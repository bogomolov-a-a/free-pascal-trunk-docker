ARG FPC_IMAGE_NAME
ARG LAZBUILD_IMAGE_NAME
FROM ${FPC_IMAGE_NAME}:latest as FREE_PASCAL_IMAGE_NAME
FROM ${LAZBUILD_IMAGE_NAME}:latest as LAZARUS_IMAGE_NAME
#make simplify image for freepascal&lazarus build process 
FROM ubuntu:latest
WORKDIR /root/
ENV SOURCE_FPC_DIR /root/fpc/trunk/lib/fpc/3.3.1
ENV FPC_DIR ./fpc
ENV SOURCE_LAZ_DIR /root/lazarus/distr
ENV LAZ_DIR ./lazarus
RUN mkdir -p $FPC_DIR
RUN mkdir -p $LAZ_DIR
COPY --from=FREE_PASCAL_IMAGE_NAME $SOURCE_FPC_DIR/ $FPC_DIR/
COPY --from=LAZARUS_IMAGE_NAME $SOURCE_LAZ_DIR/ $LAZ_DIR/
RUN cd $FPC_DIR&&ls -a
RUN cd $LAZ_DIR&&ls -a 
