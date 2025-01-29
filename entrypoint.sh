#!/bin/bash
set -e

rm -f /Portfolio/tmp/pids/server.pid

exec "$@"