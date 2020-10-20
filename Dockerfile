#make simplify image for freepascal&lazarus build process 
FROM ubuntu:latest
WORKDIR /root/
ENV SOURCE_FPC_DIR /root/fpc/trunk/lib/fpc/trunk
ENV FPC_DIR ./fpc
ENV SOURCE_LAZ_DIR /root/lazarus/distr
ENV LAZ_DIR ./lazarus
RUN mkdir -p $FPC_DIR
RUN mkdir -p $LAZ_DIR
COPY --from=$FREE_PASCAL_IMAGE_NAME:latest  $SOURCE_FPC_DIR/ $FPC_DIR/
COPY --from=$FREE_PASCAL_LAZBUILD_IMAGE_NAME:latest $SOURCE_LAZ_DIR/ $LAZ_DIR/
RUN cd $FPC_DIR&&ls -a
RUN cd $LAZ_DIR&&ls -a 
