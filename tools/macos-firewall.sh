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
TESTS_DEBUG="$OUTDIR/Debug/run-tests"

if [ -f $SFW ];
then
  # Duplicating these commands on purpose as the symbolic link node might be
  # linked to either out/Debug/node or out/Release/node depending on the
  # BUILDTYPE.
  $SFW --remove "$TESTS_DEBUG"

  $SFW --add "$TESTS_DEBUG"

  $SFW --unblock "$TESTS_DEBUG"
else
  echo "SocketFirewall not found in location: $SFW"
fi
