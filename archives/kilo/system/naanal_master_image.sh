#!/bin/sh
IMAGE_NAME=./naanal-cloud-4.00.iso
ISO_NAME=ubuntu-15.04-server-amd64.iso
OLD_ISO=oldiso
NEW_ISO=newiso

##########################

mkdir -p $OLD_ISO $NEW_ISO 
mount -o loop ./$ISO_NAME ./$OLD_ISO

cp -r ./$OLD_ISO/* ./$NEW_ISO/
cp -r ./$OLD_ISO/.disk/ ./$NEW_ISO/
mkdir -p $NEW_ISO/naanal/
cp -rf ./system  $NEW_ISO/naanal/
cp -rf ./extras ./$NEW_ISO/pool/ 

###########################

cp -rf $NEW_ISO/naanal/system/txt.cfg $NEW_ISO/isolinux/txt.cfg
#cp -rf $NEW_ISO/naanal/naanal_system/langlist $NEW_ISO/isolinux/langlist
cp -rf $NEW_ISO/naanal/system/*.ks $NEW_ISO/preseed/
cp -rf $NEW_ISO/naanal/system/*.seed $NEW_ISO/preseed/

cd $NEW_ISO 
apt-ftparchive packages ./pool/extras/ > dists/stable/extras/binary-amd64/Packages
gzip -c ./dists/stable/extras/binary-amd64/Packages | tee ./dists/stable/extras/binary-amd64/Packages.gz > /dev/null
md5sum `find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f` > md5sum.txt
cd ../
mkisofs -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -z -iso-level 4 -c isolinux/isolinux.cat -o ./$IMAGE_NAME -joliet-long  -R $NEW_ISO

###########################
