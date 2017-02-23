# Fetch the AbstractGPU
source "$WODEN2_SRC_TOP/scripts/common_scripts.sh"
fetch_git_dependency "https://github.com/ronsaldo/abstract-gpu.git" abstract-gpu

# Create the Abstract GPU build dir.
BUILD_DIR="$WODEN2_BUILD_DIR/abstract-gpu"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Build the abstract gpu
cmake "$WODEN2_SRC_TOP/abstract-gpu" -G "Unix Makefiles" $WODEN_DEPS_CMAKE_FLAGS || exit 1
make || exit 1

# Copy the results to the build dist
cp -R dist/* "$WODEN2_BUILD_DIST_DIR"

# Make symlinks to the Debug version, if they exists
if test -e "$WODEN2_BUILD_DIST_DIR/libAgpu_d.so"; then
    ln -sf "$WODEN2_BUILD_DIST_DIR/libAgpu_d.so" "$WODEN2_BUILD_DIST_DIR/libAgpu.so"
fi
if test -e "$WODEN2_BUILD_DIST_DIR/libAgpu_d.dylib"; then
    ln -sf "$WODEN2_BUILD_DIST_DIR/libAgpu_d.dylib" "$WODEN2_BUILD_DIST_DIR/libAgpu.dylib"
fi
