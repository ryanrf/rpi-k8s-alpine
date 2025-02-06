#!/bin/sh
SERVICES="nzbget sonarr radarr calibre-web transmission mealie heimdall"

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

