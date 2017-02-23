#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common32.sh

OS=`uname`
case $OS in
    Linux)
        fetch_targz "http://ronie.cl/files/lowcode/linux/release-phcoglowcodelinuxht.tar.gz" release-phcoglowcodelinuxht.tar.gz || exit
        useVM "$WODEN2_SRC_TOP/phcoglowcodelinuxht/pharo"
        ;;

    Darwin)
        fetch_zip "http://ronie.cl/files/lowcode/osx/32x86-pharo.cog.spur.lowcode-Release.zip" 32x86-pharo.cog.spur.lowcode-Release.zip || exit
        useVM "$WODEN2_SRC_TOP/Pharo.app/Contents/MacOS/Pharo"
        ;;

    *)
        echo "Unsupported operating system $OS"
        exit 1
esac
