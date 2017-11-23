# Fetch the Phanide repository
source "$WODEN2_SRC_TOP/scripts/common_scripts.sh"
fetch_git_dependency "https://github.com/ronsaldo/phanide.git" phanide

# Create the Phanide build dir.
BUILD_DIR="$WODEN2_BUILD_DIR/phanide"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Build the phanide library
cmake "$WODEN2_SRC_TOP/phanide" -G "Unix Makefiles" $WODEN_DEPS_CMAKE_FLAGS || exit 1
make || exit 1

# Copy the results to the build dist
cp -R dist/* "$WODEN2_BUILD_DIST_DIR"
