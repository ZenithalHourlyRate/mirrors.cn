#!/usr/bin/env bash
# Usage: ./serve.sh [province] [port]

set -x

if [ ! -d "dist/$1" ]; then
  echo "dist/$1 not found in current dir"
fi

if [ "$#" -lt 1 ]; then
  cd dist/ && python3 ../mirrorz/scripts/gh-cors.py $2
else
  cd dist/$1 && python3 ../../mirrorz/scripts/gh-cors.py $2
fi
