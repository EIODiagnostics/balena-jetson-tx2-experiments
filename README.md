# balena-jetson-tx2-experiments
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