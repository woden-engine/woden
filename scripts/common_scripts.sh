#!/bin/bash

fetch_targz()
{
    URL="$1"
    FILE_NAME="$2"

    wget "-O$FILE_NAME" "$URL" || exit 1
    tar -xvzf "$FILE_NAME"
}

fetch_zip()
{
    URL="$1"
    FILE_NAME="$2"

    wget "-O$FILE_NAME" "$URL" || exit 1
    unzip "$FILE_NAME"
}

useVM()
{
    exec "$WODEN2_SRC_TOP/useVM.sh" $1
}
