#!/bin/bash
set -xeo pipefail

sudo cgm create all linas
sudo cgm chown all linas $(id -u) $(id -g)
cgm movepid all linas $$

sudo brctl addbr lxcbr0
sudo ifconfig lxcbr0 10.0.3.1/24 up
sudo service apt-cacher-ng start
sudo service cgmanager start

cp /etc/hosts /gitian/hosts.orig
echo "10.0.3.5 gitian" >> /gitian/hosts.orig
sudo cp /gitian/hosts.orig /etc/hosts 

sudo chown -R gitian /gitian 
sudo chown -R gitian /data
test -f /data/gitian-builder || mkdir -pv /data/gitian-builder
echo "Testing Write Access to /data/gitian-builder"
echo "Your Local build.sh should have configured this"
echo -e "to map to \$NAMESPACE/gitian-builder"
echo -e "and should be owned by the the local user"
echo -e "executing build.sh"
echo "USE_LXC=1" > /data/gitian-builder/gitian_builder.env
echo "GITIAN_HOST_IP=10.0.3.1" >> /data/gitian-builder/gitian_builder.env
echo "LXC_GUEST_IP=10.0.3.5" >> /data/gitian-builder/gitian_builder.env

cd /gitian/gitian-builder

 test -d /data/gitian-builder/.git || cp -av /gitian/gitian-builder /data
 #test -f  /data/gitian-builder/base-xenial-i386  || ./bin/make-base-vm --lxc --arch i386  --suite xenial 
 #test -f  /data/gitian-builder/base-xenial-i386  || cp -av /gitian/gitian-builder/base-xenial-i386  /data/gitian-builder
 test -f  /data/gitian-builder/base-xenial-amd64 || ./bin/make-base-vm --lxc --arch amd64 --suite xenial 
 test -f  /data/gitian-builder/base-xenial-amd64 || cp -av /gitian/gitian-builder/base-xenial-amd64  /data/gitian-builder
echo "Now you're ready to run a build"
echo "docker run -it --rm --privileged -c $(pwd)/${GD_BUILD_COIN}-src:/gitian/${GD_BUILD_COIN} -v $(pwd)/gitian-builder:/gitian/gitian-builder  guruvan/gitian-builder"



