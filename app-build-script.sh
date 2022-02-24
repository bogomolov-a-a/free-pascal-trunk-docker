git clone https://github.com/bogomolov-a-a/free-pascal-application-util-packages.git&&\
$LAZ_BUILD_PATH --verbose --lazarusdir=$LAZDIR --compiler=$COMPILER_PATH ./free-pascal-application-util-packages/freepascal-application-common/src/main/freepascalapplicationcommon.lpk&&\
ls ./$LAZ_BUILD_DSL_APP_SOURCE_PATH -a &&\
$LAZ_BUILD_PATH --verbose --lazarusdir=$LAZDIR --compiler=$COMPILER_PATH ./$LAZ_BUILD_DSL_APP_SOURCE_PATH/$LAZ_BUILD_DSL_APP_NAME.lpi&&\
cp ./target/$LAZ_BUILD_DSL_APP_NAME ./$LAZ_BUILD_DSL_APP_NAME&&\
rm ./$LAZ_BUILD_DSL_APP_SOURCE_PATH -rf&&
rm ./target -rf&&
rm ./free-pascal-application-util-packages -rf