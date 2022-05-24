#!/bin/sh

SERVICE=$1
HOST_GROUP=${2:=all}

ansible ${HOST_GROUP}  -m service -a "name=${SERVICE} state=restarted"
