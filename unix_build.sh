#!/bin/bash

usage()
{
    echo "Usage $0 [-c Debug|Release] [-l (switch - Run configuration first)]" 1>&2
    exit 1
}

# Defaults
configuration=Debug
clean_configure=false

# Parse the arguments
while getopts ":c:l" opt; do
    case $opt in 
        c) configuration="$OPTARG";;
        l) clean_configure=true;;
        \?) echo "Invalid option [-$OPTARG]" 1>&2
            usage ;;
        :)  echo "Option [-$OPTARG] requires an argument" 1>&2 
            usage ;;
    esac
done

source_root_dir=$(pwd)
build_dir=$(pwd)/out/build/$configuration
#install_dir=$(pwd)/out/install/$configuration

pushd scripts/unix
echo "Current dir: $(pwd)"

if [ "$clean_configure" == true ]; then
    echo "Removing build dir"
    rm -rf $build_dir
    ./configure.sh -c $configuration -s $source_root_dir -b $build_dir
fi

./build.sh -b $build_dir -c $configuration

popd
echo "Current dir: $(pwd)"