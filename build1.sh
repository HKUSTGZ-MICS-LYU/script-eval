#!/bin/bash
set -Exeuo pipefail

eval_commit=$(git describe --dirty --always)
rtl_commit=$1
clock_freq=$2

echo Building scrypt commit $rtl_commit, clock $clock_freq MHz, eval commit $eval_commit



# clone and checkout
build_dir=${eval_commit}_${rtl_commit}_${clock_freq}

mkdir -p build
cd build
if [ -e "$build_dir" ] ; then
    echo Rebuilding
    rm -rf "$build_dir"
fi
git clone git@github.com:cysic-labs/scrypt.git ${build_dir}
cd ${build_dir}
git checkout $rtl_commit