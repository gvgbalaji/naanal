#!/bin/sh
IMAGE_NAME=./naanal-vcp-3.00.iso
ISO_FOLDER=newiso

cp -rf $ISO_FOLDER/naanal/system/txt.cfg $ISO_FOLDER/isolinux/txt.cfg
#cp -rf $ISO_FOLDER/naanal/naanal_system/langlist $ISO_FOLDER/isolinux/langlist
cp -rf $ISO_FOLDER/naanal/system/*.ks $ISO_FOLDER/preseed/
cp -rf $ISO_FOLDER/naanal/system/*.seed $ISO_FOLDER/preseed/

cd $ISO_FOLDER 
apt-ftparchive packages ./pool/extras/ > dists/stable/extras/binary-amd64/Packages
gzip -c ./dists/stable/extras/binary-amd64/Packages | tee ./dists/stable/extras/binary-amd64/Packages.gz > /dev/null
md5sum `find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f` > md5sum.txt
cd ../
mkisofs -J -l -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -z -iso-level 4 -c isolinux/isolinux.cat -o ./$IMAGE_NAME -joliet-long $ISO_FOLDER

