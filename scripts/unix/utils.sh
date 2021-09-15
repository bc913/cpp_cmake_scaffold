#!/bin/bash

check_config() {
    if [[ -z "$1" ]]; then
        echo "Error: Configuration argument [-c] can not be empty."
        exit -1
    fi

    if [[ $1 != Debug && $1 != Release ]]; then
        echo "Error: Configuration should be one of these: Debug | Release."
        exit -1
    fi
}

# Check for null (not empty) before calling otherwise $1 will be the error message
dir_exists() {

    if [[ -d $1 ]]; then
        echo "Dir exists: $1"
    else
        echo "Error: $2 $1"
        exit -1
    fi
}