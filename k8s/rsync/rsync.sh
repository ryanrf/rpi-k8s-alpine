#!/bin/bash -x

SERVICE_TO_COPY=$1

usage(){
  echo "usage: $0 <SERVICE TO COPY>"
  exit 1
}

if [[ -z $SERVICE_TO_COPY ]]
then
  echo "missing SERVICE TO COPY"
  usage
fi

kubectl -n default get job/rsync && kubectl -n default delete job/rsync
sed "s/REPLACE/$SERVICE_TO_COPY/" job.yaml | kubectl -n default apply -f -
