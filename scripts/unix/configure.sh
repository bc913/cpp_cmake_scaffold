#!/bin/bash

source ./utils.sh

usage()
{
    echo "Usage $0 [-c Debug|Release] [-b BUILD_DIR] [-s SOURCE_ROOT_DIR] [-i INSTALL_DIR (Optional)]" 1>&2
    exit 1
}

# ===============
# Command
# ===============

# Parse the arguments
while getopts ":b:c:i:s:h:" opt; do
    case $opt in 
        b) build_dir="$OPTARG" ;;
        c) config="$OPTARG" ;;
        i) install_dir="$OPTARG" ;;
        s) source_root_dir="$OPTARG" ;;
        h) usage ;;
        \?) echo "Invalid option [-$OPTARG]" 1>&2
            usage ;;
        :)  echo "Option [-$OPTARG] requires an argument" 1>&2 
            usage ;;
    esac
done

echo "=============="
echo "configure.sh"
echo "=============="
echo ""

# Arguments
echo "Arguments:"
echo "[-b]build_dir: $build_dir"
echo "[-c]configuration: $config"
echo "[-s]source_root_dir: $source_root_dir"
echo "[-i]install_dir: $install_dir"
echo ""

# Checks
check_config $config
if [[ -z $source_root_dir ]]; then
    echo "Error: Source root dir can not be null or empty."
    exit 1
fi
dir_exists $source_root_dir "Source root directory do not exist: "

# Make sure utility functions are loaded
if [[ "$?" -eq 127 ]]; then
    echo "Make sure utility functions are loaded properly."
    exit 1
fi

# Run
if [[ -z "$install_dir" ]]; then
    echo "Friendly Warning: No install dir is specified."
    cmake -S $source_root_dir -B $build_dir -DCMAKE_BUILD_TYPE=$config
else
    cmake -S $source_root_dir -B $build_dir -DCMAKE_BUILD_TYPE=$config -DCMAKE_INSTALL_PREFIX=$install_dir 
fi

echo ""
