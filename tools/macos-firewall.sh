#!/bin/bash
# Script that adds rules to Mac OS X Socket Firewall to avoid
# popups asking to accept incoming network connections when
# running tests.
SFW="/usr/libexec/ApplicationFirewall/socketfilterfw"
TOOLSDIR="`dirname \"$0\"`"
TOOLSDIR="`( cd \"$TOOLSDIR\" && pwd) `"
ROOTDIR="`( cd \"$TOOLSDIR/..\" && pwd) `"
OUTDIR="$TOOLSDIR/../out"
# Using cd and pwd here so that the path used for socketfilterfw does not
# contain a '..', which seems to cause the rules to be incorrectly added
# and they are not removed when this script is re-run. Instead the new
# rules are simply appended. By using pwd we can get the full path
# without '..' and things work as expected.
OUTDIR="`( cd \"$OUTDIR\" && pwd) `"
PROJECT_DIR="$TOOLSDIR/../"
PROJECT_DIR="`( cd \"$PROJECT_DIR\" && pwd) `"
TESTS_DEBUG="$OUTDIR/Debug/run-tests"
TESTS_LIBS="$PROJECT_DIR/test/.libs/run-tests"
echo $TESTS_DEBUG
echo $TESTS_LIBS

if [ -f $SFW ];
then
  # Duplicating these commands on purpose as the symbolic link node might be
  # linked to either out/Debug/node or out/Release/node depending on the
  # BUILDTYPE.
  $SFW --remove "$TESTS_DEBUG"
  # This will cause a segment fault, perhaps because of the dot in the 
  # name of the file. 
  #$SFW --remove "$TEST_LIBS"

  $SFW --add "$TESTS_DEBUG"
  $SFW --add "$TESTS_LIBS"

  $SFW --unblock "$TESTS_DEBUG"
  $SFW --unblock "$TESTS_LIBS"
else
  echo "SocketFirewall not found in location: $SFW"
fi
