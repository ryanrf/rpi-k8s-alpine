#!/bin/bash -e
CONTROL=rpi31
SERVICES="nzbget sonarr radarr organizr plex"

if [[ ! -z $1 ]]
then
  SERVICES=$@
fi

echo "Copying files to $CONTROL for deployment"
rsync -aq $SERVICES rpi31:
echo "Beginning deployment..."
for i in $SERVICES
do
  echo "Deploying $i"
  ssh $CONTROL "kubectl apply -k $i/"
  ssh $CONTROL "rm -rf $i"
done
echo "Done"

