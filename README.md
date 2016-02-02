# gitian-docker 

Build coin daemons & QT wallets with gitian in docker

Requires Docker 1.7+ installed on a build host

Host may be local iron, AWS (or other) instance, or Virtualbox VM

Currently testing has been done with:
  - Travis-CI.org
    - [.travis.yml example](https://github.com/shastafareye/travis-docker-example)
    - MAZA 0.10.2 will not complete if ALL steps are performed on travis as per the example above
    - travis build pulls [maza/gitian-travis](https://github.com/guruvan/gitian-docker/blob/master/Dockerfile) which is an Automated Build on Dockerhub
    - Travis caching may or may not work in the example provided
    - Builds currently succeed, with fail marks (hashes are provided, travis marks build as failed because a script commend exited non-zero)
  - Macbook Pro 
     - OSX El Capitan
     - Docker 1.9.1
     - VirtualBox 5.0.14
     - Docker-Toolbox
     - build success is dependent on correct write perms
         - needs additional scripting to:
	    - detect OS / Docker-Toolbox use
	    - ensure that the build directory is mounted in the VM w/ correct perm/owner
	    - Docker build is set to accommodate correct Vbox use
       

  - AWS m4.xlarge instance 
     - Ubuntu 15.10
     - Docker 1.9.1
     - Builds are successful
  

## Quick Start

 ```
 ./build.sh [ENVFILE]
 ```
 e.g.
 ```
 ./build.sh maza-10.2.env

To change coins, simply make a new env file with the correct variables set

## MOAR
 (or, we know you like to build stuff so we'll build a builder for your builder so you can build moar)

 - ./build.sh 
   sets a few variables, corrects the Dockerfiles, and runs the docker containers for you
 - make_gitian_vms.sh runs in the stage1 container, and sets up the gitian build environment for you
 - gitian_build.sh runs in the builder container and performs the build 
    - currently this builds win, linux, osx 

This will take the stock dockerfile and build one we'll use to build the Stage1 Container
Stage 1 container will 
  - clone a fresh copy of your source
  - get the gitian-builder
  - make the base "VMs" (LXC containers) for your gitian builds
  - copy those base-vms to your LOCAL disk
  - produce a Dockerfile for the gitian-builder container

Stage 2 Gitian-Builder container is build with your NAMESPACE (your username) 
and sets the entry point for the next script. 


