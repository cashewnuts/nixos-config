#!/bin/sh

SCRIPT_PATH="$0"
TARGET=${1:-.}
# Convert to absolute path if needed
case "$SCRIPT_PATH" in
    /*) SCRIPT_ABS="$SCRIPT_PATH" ;;
    *) SCRIPT_ABS="$(pwd)/$SCRIPT_PATH" ;;
esac

SCRIPT_DIR=$(dirname $(realpath "$SCRIPT_ABS"))

ln -s "$SCRIPT_DIR/../nix-config" $TARGET

