#!/bin/sh
SERVICES="nzbget sonarr radarr organizr plex calibre-web transmission"

if [ ! -z $1 ]
then
  SERVICES=$@
fi

echo "Beginning deployment..."
for i in $SERVICES
do
  echo "Deploying $i"
  kubectl apply -k $i
done
echo "Done"

