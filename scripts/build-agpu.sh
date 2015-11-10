#!/bin/bash

# Create the Abstract GPU build dir.
BUILD_DIR="$WODEN2_BUILD_DIR/abstract-gpu"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Build the abstract gpu
cmake "$WODEN2_SRC_TOP/abstract-gpu" -G "Unix Makefiles" || exit 1
make || exit 1

# Copy the results to the build dist
cp -R dist/* "$WODEN2_BUILD_DIST_DIR"

