#!/bin/bash
set -e

# Get the parent directory of where this script is.
SCRIPT_DIR="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_DIR" ] ; do SCRIPT_DIR="$(readlink "$SCRIPT_DIR")"; done
PROJECT_DIR="$( cd -P "$( dirname "$SCRIPT_DIR" )/.." && pwd )"

# Set vars
REPO=https://github.com/ComplianceAsCode/content.git
PROFILES=( C2S stig )
MAKE_TARGETS=( rhel6-content rhel7-content centos6-content centos7-content )
BUILD_DIR="${PROJECT_DIR}/build/content"
DIST_DIR="${PROJECT_DIR}/scap/content/guides/openscap"

# Remove old SSG dist directory
echo "Removing directory ${BUILD_DIR}..."
rm -rf "$BUILD_DIR"

# Clone the repo and checkout the latest tag
git clone "$REPO" "$BUILD_DIR" && pushd "$BUILD_DIR"
TAG="$(git describe --abbrev=0 --tags)"
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
cmake ../
make -j4 "${MAKE_TARGETS[@]}"
cp *-ds.xml *-xccdf.xml *-oval.xml *-cpe-dictionary.xml "$DIST_DIR"
echo
echo 'Done building content!'

popd
