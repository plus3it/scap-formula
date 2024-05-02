#!/bin/bash
set -e

# Set vars
REPO=https://github.com/ComplianceAsCode/content.git
PROFILES=( C2S stig )
MAKE_TARGETS_RHEL=(
  rhel7-content
  rhel8-content
  rhel9-content
)
MAKE_TARGETS_OTHERS=(
  centos7-content
  centos8-content
  cs9-content
  ol8-content
  ol9-content
)
TMPDIR="${TMPDIR:-/tmp}"
BUILD_DIR="${TMPDIR}/ComplianceAsCode/content"
DIST_DIR="${TMPDIR}/dist"

export SOURCE_DATE_EPOCH=1614699939

# Remove old SSG build directory
echo "Removing directory ${BUILD_DIR}..."
rm -rf "$BUILD_DIR" "$DIST_DIR"

mkdir -p "$DIST_DIR"
exec > >(tee "${DIST_DIR}/build-content.log") 2>&1

# Clone the repo and checkout the latest tag
git clone "$REPO" "$BUILD_DIR" && pushd "$BUILD_DIR"
TAG="${SSG_VER:-$(git describe --tags $(git rev-list --tags --max-count=1))}"
echo
echo "Tag to build: ${TAG}"
echo
git checkout "$TAG"
echo

# Update standard_profiles
echo "Ensuring ssg content includes required profiles: ${PROFILES[@]}"
ssg_constants="${BUILD_DIR}/ssg/constants.py"
for profile in "${PROFILES[@]}"
do
  if grep -e 'standard_profiles' "$ssg_constants" | grep -e \'$profile\'; then
    echo "-- Profile $profile already exists.  Will not be added."
  else
    echo "-- Profile $profile was not found. $profile will be added to standard_profiles."
    sed -i '/standard_profiles = \[/ s/]/,\ '\'$profile\''&/' "$ssg_constants"
  fi
done
echo "Done adding profiles..."
echo

# Build content
echo "Building ssg xml content..."
echo
cd build

# Build SCAP 1.3 content
# more info here: https://complianceascode.readthedocs.io/en/latest/manual/developer/02_building_complianceascode.html#building

cmake -G Ninja -DSSG_TARGET_OVAL_MINOR_VERSION:STRING=11 ../

# Build RHEL first to generate dependencies for CentOS and Oracle Linux
ninja -j 4 "${MAKE_TARGETS_RHEL[@]}"
ninja -j 4 "${MAKE_TARGETS_OTHERS[@]}"

cp *-ds.xml *-xccdf.xml *-oval.xml *-cpe-dictionary.xml *-ocil.xml "$DIST_DIR"

echo
echo 'Done building content!'

popd
