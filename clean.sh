#!/bin/bash

if ls *.qcow2 1>/dev/null 2>&1; then
    rm *.qcow2
fi
if ls *.img 1>/dev/null 2>&1; then
    rm *.img
fi
if ls *.raw 1>/dev/null 2>&1; then
    rm *.raw
fi
if [ "$1" == "full" ]; then
    rm *.xz
fi