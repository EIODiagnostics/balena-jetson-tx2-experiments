# balena-jetson-tx2-experiments

Successful Experimental Branch: resin-jetson-tx2-debian-with-explicit-openjdk8

* This branch has a working systemd in the Server container.
* This branch has a working cuda driver in the Server container.
* This branch is based on resin-jetson-tx2-debian
* This branch contains a snippet from https://github.com/balena-io-library/base-images/blob/master/balena-base-images/openjdk/jetson-tx2/debian/stretch/8-jdk/build/Dockerfile
* This branch contains a snippet from https://github.com/open-horizon/cogwerx-jetson-tx2/Dockerfile.cudabase

Experiments building balena containers for Nvidia Jetson TX2

Each attempt is on a different branch.

To use this:
- clone this repository
- get an Nvidia Jetson TX2 on it's development board
- create an application at https://dashboard.balena-cloud.com for a Jetson TX2
- follow the instructions to download the image, flash it to an SD Card, boot the Jetson TX2 with it, etc.
- add the balena git remote to your clone of this repository
- `git push balena`
- wait for the docker container to be built and uploaded
- wait for the image to be downloaded to your Jetson TX2
- use https://dashboard.balena-cloud.com to monitor the progress of the installation and the success of the testInstallation.bash script
