#!/bin/bash -e

./start.sh $1

if [ "$?" -ne 0 ]; then
    exit 1
fi

node enrollAdmin.js org2
node registerUser.js org2
node query.js org2
