#!/bin/bash

SRC=$1

rsync -av library:/volume1/downloads/completed_torrents/${SRC} .
rsync -av ${SRC} rpi31:

ssh rpi31 'kubectl -n dl cp ${SRC} $(kubectl -n dl get pods -l app=sonarr -o jsonpath="{.items[0].metadata.name}"):/tmp/'
curl -v -H "X-Api-Key: 7d9cd4fc710a4f538eac8bbec01f680f" "http://media.faircloth.ca/sonarr/api/v3/filesystem?path=/tmp/${SRC}&allowFoldersWithoutTrailingSlashes=false&includeFiles=false"
