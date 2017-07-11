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
        fetch_tar "http://ronie.cl/files/lowcode/osx/cog_macos64x64_pharo.cog.spur.lowcode_201707112009.tar" cog_macos64x64_pharo.cog.spur.lowcode_201707112009.tar || exit 1
        fetch_zip "http://files.pharo.org/get-files/60/sources.zip" PharoSourcesV60.zip || exit 1

        useVM "$WODEN2_SRC_TOP/Pharo.app/Contents/MacOS/Pharo"
        ;;

    *)
        echo "Unsupported operating system $OS"
        exit 1
esac
