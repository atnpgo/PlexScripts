#!/bin/bash

#####################################################################################################################################
#                                                                                                                                   #
# Script to dim, turn on or turn off a set of Phillips Hue lights.                                                                  #
# First argument is one of:                                                                                                         #
#   1- on: Turns the lights in the main room on                                                                                     #
#   2- off: Turns all the lights off                                                                                                #
#   3- dim: Turns the lights in the main room on at 25% brightness                                                                  #
# Second argument is your username as obtained when following the steps on https://developers.meethue.com/develop/get-started-2/    #
# Third (optional) argument is the name of the main room to override the default of "Living room"                                   #
#                                                                                                                                   #
#####################################################################################################################################

ROOM_NAME="${3:-Living room}"
BRIDGE_IP=$(curl https://discovery.meethue.com -s | /usr/local/bin/jq '.[0].internalipaddress' -r)
INPUT=$(echo "$1" | awk '{print tolower($0)}');
USER=$2
case $INPUT in
"on")
    for GROUP in $(curl "http://$BRIDGE_IP/api/$USER/groups" -s | /usr/local/bin/jq ". | to_entries | .[] | select(.value.type==\"Room\")  | select(.value.name==\"$ROOM_NAME\").key" -r)
    do
        curl -s -X PUT -d '{"on":true,"bri":254}' "http://$BRIDGE_IP/api/$USER/groups/$GROUP/action" > /dev/null
        sleep .05
    done
    ;;
"off")
    for GROUP in $(curl "http://$BRIDGE_IP/api/$USER/groups" -s | /usr/local/bin/jq '. | to_entries | .[] | select(.value.type=="Room").key' -r)
    do
        curl -s -X PUT -d '{"on":false}' "http://$BRIDGE_IP/api/$USER/groups/$GROUP/action" > /dev/null
        sleep .05
    done
    ;;
"dim")
    for GROUP in $(curl "http://$BRIDGE_IP/api/$USER/groups" -s | /usr/local/bin/jq ". | to_entries | .[] | select(.value.type==\"Room\")  | select(.value.name==\"$ROOM_NAME\").key" -r)
    do
        curl -s -X PUT -d '{"on":true,"bri":64}' "http://$BRIDGE_IP/api/$USER/groups/$GROUP/action" > /dev/null
        sleep .05
    done
    ;;
esac
