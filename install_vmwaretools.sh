#!/bin/bash
# This script is to install vmwaretools after the "cd" has been loaded from the console

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
mkdir -p /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
cd /tmp
cp /mnt/cdrom/VMwareTools-*.tar.gz  .
tar -xvf VMwareTools-*.tar.gz
cd vmware-tools-distrib
./vmware-install.pl d
#   accept the defaults (with the d option)

# after it finishes successfully,  (it unmouts the cdrom itself)
cd ..
rm -rf vmware-tools-distrib
rm -rf VMwareTools-*.gz

echo "finished"
