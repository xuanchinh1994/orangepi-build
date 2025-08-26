echo "==========================================================="
echo "Loading Docker Image"
echo "==========================================================="
docker load -i voyd_build_docker.tar.gz

echo "==========================================================="
echo "Cloning Source Code"
echo "==========================================================="
rm -rf orangepi-build/
git clone https://github.com/orangepi-xunlong/orangepi-build.git
cd orangepi-build/
git checkout 2dbd451489d87de055209695e354051385688fe4
git apply ../0001-Add-VOYD-device-support.patch
git apply ../0002-Fix-cannot-reboot-after-WIFI-setup.patch
cd ../


echo "==========================================================="
echo "Setup Build Environment Successfully"
echo "==========================================================="

sudo ./build.sh  BOARD=orangepizero2 BRANCH=next BUILD_OPT=image RELEASE=jammy BUILD_MINIMAL=no BUILD_DESKTOP=yes KERNEL_CONFIGURE=no DESKTOP_ENVIRONMENT=gnome DESKTOP_ENVIRONMENT_CONFIG_NAME=config_base DESKTOP_APPGROUPS_SELECTED="browsers" COMPRESS_OUTPUTIMAGE=sha,gpg,img