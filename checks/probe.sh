#!/bin/sh
set -e
H=http://web
# /password/test answers with the benchmark's own page.
curl -fsS "$H/password/test" | grep -qF 'Trading Platform'
