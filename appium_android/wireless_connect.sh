#!/usr/bin/env bash
!/bin/bash
#ANDROID_DEVICES="011f6a709805"
if [ ! -z "$ANDROID_DEVICES" ]; then
    curl -X POST \
      http://$PUBLIC_IP/api/v1/user/devices \
      -H 'Authorization: Bearer '"$STF_TOKEN" \
      -H 'Content-Type: application/json' \
      -d '{"serial":"'$ANDROID_DEVICES'"}'
    response=$(curl -s -X GET   http://$PUBLIC_IP/api/v1/devices/$ANDROID_DEVICES   -H 'Authorization: Bearer '"$STF_TOKEN")
    echo $response
    connect_url=$( jq -r .device.remoteConnectUrl <<< "${response}" )
    echo ${connect_url}
    adb connect ${connect_url}
    echo "Success!"
    sleep 1
    adb devices
fi
