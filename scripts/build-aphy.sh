# Fetch the AbstractPhysics
source "$WODEN2_SRC_TOP/scripts/common_scripts.sh"
fetch_git_dependency "https://github.com/ronsaldo/abstract-physics.git" abstract-physics

# Create the Abstract Physics build dir.
BUILD_DIR="$WODEN2_BUILD_DIR/abstract-physics"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Build the abstract gpu
cmake "$WODEN2_SRC_TOP/abstract-physics" -G "Unix Makefiles" $WODEN_DEPS_CMAKE_FLAGS || exit 1
make || exit 1

# Copy the results to the build dist
cp -R dist/* "$WODEN2_BUILD_DIST_DIR"
