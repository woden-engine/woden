#!/bin/bash

fetch_git_dependency()
{
    URL="$1"
    FOLDER_NAME="$1"
    TARGET="$WODEN2_SRC_TOP/$FOLDER_NAME"

    if test ! -d "$TARGET"; then
        git clone "$URL" "$TARGET" || exit 1
    fi
}

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

execVM()
{
    VM_ARGS="$@"
    if test ! -e "$WODEN2_SRC_TOP/woden2.sh"; then
        echo "A VM has not been selected to use with Woden2. Please select a VM with the useVM.sh script."
        exit 1
    fi

    exec "$WODEN2_SRC_TOP/woden2.sh" $VM_ARGS
}
