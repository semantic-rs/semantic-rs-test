#!/bin/bash

set -e

git clone https://github.com/sstephenson/bats/ || true
export PATH=$(pwd)/bats/bin:$PATH

rm -rf ../workspace
mkdir ../workspace
cp -ar fixtures/* ../workspace

HOME=$(readlink -f ..) bats integration.bats
