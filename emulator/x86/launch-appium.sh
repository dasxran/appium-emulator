#!/bin/bash

DEFAULT_CAPABILITIES_JSON="/root/defaultcapabilities.json"
APPIUM_LOG="${APPIUM_LOG:-/var/log/appium.log}"
CMD="appium --log $APPIUM_LOG"

if [ "$DEFAULT_CAPABILITIES" = true ]; then
    CMD+=" --default-capabilities $DEFAULT_CAPABILITIES_JSON"
fi

if [ "$RELAXED_SECURITY" = true ]; then
    CMD+=" --relaxed-security"
fi

if [ "$ADB_SHELL" = true ]; then
    CMD+=" --allow-insecure adb_shell"
fi

nohup $CMD &
