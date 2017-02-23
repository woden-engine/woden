#!/bin/bash
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MY_DIR/scripts/common64.sh

OS=`uname`
case $OS in
    Linux)
        fetch_targz "http://ronie.cl/files/lowcode/linux/release-phcoglowcode64linuxht.tar.gz" release-phcoglowcode64linuxht.tar.gz || exit 1
        useVM "$WODEN2_SRC_TOP/phcoglowcodelinuxht/pharo"
        ;;

    Darwin)
        fetch_zip "http://ronie.cl/files/lowcode/osx/64x64-pharo.cog.spur.lowcode-Release.zip" 64x64-pharo.cog.spur.lowcode-Release.zip || exit 1
        fetch_zip "http://files.pharo.org/get-files/50/sources.zip" PharoSourcesV50.zip || exit 1

        # Zip does not preserve a symlink.
        ln -sf "$WODEN2_SRC_TOP/Pharo.app/Contents/MacOS/Plugins/libSDL2-2.0.0.dylib" "$WODEN2_SRC_TOP/Pharo.app/Contents/MacOS/Plugins/libSDL2.dylib"

        useVM "$WODEN2_SRC_TOP/Pharo.app/Contents/MacOS/Pharo"
        ;;

    *)
        echo "Unsupported operating system $OS"
        exit 1
esac
