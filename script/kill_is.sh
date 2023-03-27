#!/bin/bash

#Purpose: This script will kill the webmethod Integration Server processes



# It checks whether the current user is wmadmin or not ?
if [[ `whoami` != "wmadmin" ]]
then
   echo "\nYou are logged in as `whoami`."
   exit 1
fi

# Find the correct Integration Server directory\

# The below part totally depends on the version of the integration server. Like wm_1011 shows it is webmethdo 10.11 version.
if [[ -d /wm_1011/ ]]
then
   IS_directory=/wm_1011/IntegrationServer
elif [[ -d /wm_is/v61 ]]
then
   IS_directory=/wm_is/v61/IntegrationServer
else
   IS_directory=/wm_is/IntegrationServer
fi

echo "Finding Integration Server processes..."
for process in `ps -ef|grep -v grep|grep -v reposerver|grep wmadmin|grep -w "IntegrationServer"|awk '{print $2}'`
do
  echo "Now killing process $process..."
  kill -9 $process
done

deployer_process=`ps -ef|grep wmadmin|grep "packages\/WmDeployer"|awk '{print $2}'`
if [[ $deployer_process != "" ]]
then
   echo "Killing Deployer process $deployer_process..."
   kill -9 $deployer_process
fi

if [[ -f ${IS_directory}/LOCKFILE ]]
then
   echo "Removing LOCKFILE..."
   rm ${IS_directory}/LOCKFILE
fi

echo "The webmethods integration server is now shut down."
