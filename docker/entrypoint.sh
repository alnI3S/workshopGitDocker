#!/bin/bash

if [ -n "${LOCAL_USER_ID}" ]; then
echo "Starting with UID: $LOCAL_USER_ID"
usermod -u $LOCAL_USER_ID user
# add other customization linux commandes here
fi

exec "$@"
