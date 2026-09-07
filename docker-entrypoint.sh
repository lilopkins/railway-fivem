#!/bin/sh

/sbin/tini -- /usr/bin/entrypoint +set txDataPath /config/txData $*

