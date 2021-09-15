#!/bin/bash

source ./utils.sh

usage()
{
    echo "Usage $0 [-c Debug|Release] [-b BUILD_DIR]" 1>&2
    exit 1
}

# ===============
# Command
# ===============

# Parse the arguments
while getopts ":b:c:h:" opt; do
    case $opt in 
        b) build_dir="$OPTARG" ;;
        c) configuration="$OPTARG" ;;
        h) usage ;;
        \?) echo "Invalid option [-$OPTARG]" 1>&2
            usage ;;
        :)  echo "Option [-$OPTARG] requires an argument" 1>&2 
            usage ;;
    esac
done

echo "=============="
echo "build.sh"
echo "=============="

# Arguments
echo "Arguments:"
echo "[-b]build_dir: $build_dir"
echo "[-c]configuration: $configuration"
echo ""

# Checks
if [[ -z $build_dir ]]; then
    echo "Error: Build directory can not be null or empty."
    exit 1
fi
dir_exists $build_dir "Build directory do not exist. Make sure you configure the project first."

# Run
cmake --build $build_dir --config $configuration

echo ""