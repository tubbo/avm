#!/usr/bin/env bash
#
# Script for installing AVM to the system.

if [[ $(uname) == 'Darwin' ]]; then
  mktmp="mktemp"
else
  mktmp="mktmp"
fi

# Find latest released version from GitHub API
repo="https://api.github.com/repos/tubbo/avm/releases/latest"
version=$(curl --silent "$repo" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
tmpdir=$($mktmp -d)
sourcedir="avm-${version:1}"
filename="avm-$version.tar.gz"

# Ensure source code is in place
echo "Downloading avm $version from GitHub..."
pushd "$tmpdir" > /dev/null 2>&1
curl -sL "https://github.com/tubbo/avm/archive/$version.tar.gz" -o "$filename"

# Extract source code and install
tar -zxf "$filename"
pushd "$sourcedir" > /dev/null 2>&1
make install
code=$?

# Print whether avm was installed or not
if [[ "$code" == 0 ]]; then
  echo "avm $version has been installed!"
  echo "Get started by running \`avm\` to view usage"
  echo "Or, run \`man homer\` to see all documentation"
else
  echo "Error installing avm"
fi

# Clean up the source directory
popd > /dev/null 2>&1
popd > /dev/null 2>&1
rm -rf "$tmpdir"

exit $code
