#!/bin/bash

profiles_to_add=( C2S stig )

make_targets=( rhel6 rhel7 centos6 centos7 )

# Remove old SSG content folder or similarly named folder
echo "Removing 'content' folder..."
rm -rf content

git clone https://github.com/ComplianceAsCode/content.git && cd content

for profile in "${profiles_to_add[@]}"
do
  if grep -e 'standard_profiles' ssg/constants.py | grep -e \'$profile\'; then
    echo "$profile already exists.  Will not be added."
  else
    echo "Proile $profile was not found. $profile will be added to standard_profiles."
    sed -i '/standard_profiles = \[/ s/]/,\ '\'$profile\''&/' ssg/constants.py
  fi 
done

cd build

cmake ../

for target in "${make_targets[@]}"
do
  make -j4 $target
done

cp ssg-centos6-ds.xml ../../../scap/content/guides/openscap/.
cp ssg-centos6-xccdf.xml ../../../scap/content/guides/openscap/. 
cp ssg-centos7-ds.xml ../../../scap/content/guides/openscap/.
cp ssg-centos7-xccdf.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel6-cpe-dictionary.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel6-cpe-oval.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel6-ds.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel6-oval.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel6-xccdf.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel7-cpe-dictionary.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel7-cpe-oval.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel7-ds.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel7-oval.xml ../../../scap/content/guides/openscap/.
cp ssg-rhel7-xccdf.xml ../../../scap/content/guides/openscap/.


