#!/usr/bin/env bash

# loop_thresholds.sh
# Jim Bagrow
# Last Modified: 2009-03-10


# Copyright 2009,2010 James Bagrow
# 
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

usage() {
    echo 1>&2 "USAGE: $0 [options]

Loop over many thresholds, recording the clusters at each. Must pass arguments
for -p and -j.

OPTIONS:
   -h    Show this message only
   -p    Pairs file.
   -j    Jaccard similarity file for given pairs file.
   -s    Scripts directory, where jaccard calculation and cluster scripts are
   -c    Alternate name for clustering script; default is clusterJaccards
   -o    Output directory; defualts to \"clusters\" in cwd; created if absent"
}

# Error codes
BAD_USAGE=600
NO_PAIRS_FILE=601
NO_JACCS_FILE=602
UNABLE_TO_MAKE_OUTPUT_DIR=603

# Parse command line arguments
PAIRS_FILE=
JACCS_FILE=
SCRIPTS_DIR=$(pwd)
OUTPUT_DIR=$(pwd)/clusters
CLUST_SCRIPT="clusterJaccards"

while (( "$#" ))
do
    # For flags with values, shift is used in-line to move past the value.
    case $1 in
        -h|--help)
            usage;
            exit 0
            ;;
        -p|--pairs-file)
            PAIRS_FILE="$2"
            shift
            ;;
        -j|--jacc-sim-file)
            JACCS_FILE="$2"
            shift
            ;;
        -s|--scripts-dir)
            SCRIPTS_DIR=$2
            shift
            ;;
        -c|--cluster-script)
            CLUST_SCRIPT=$2
            shift
            ;;
        -o|--output-dir)
            OUTPUT_DIR=$2
            shift
            ;;
    esac
    shift # decrement all arglist indices
done

# Ensure we have the necessary files
if [[ -z "$PAIRS_FILE" ]]; then
    echo "Pairs file is required to run. None given."
    exit $BAD_USAGE
fi

if [[ -z "$JACCS_FILE" ]]; then
    echo "Jaccard similarity file is required to run. None given."
    exit $BAD_USAGE
fi

# Inform the user of our progress.
echo "Using link community detection scripts from: ${SCRIPTS_DIR}"
echo "Writing to output directory: ${OUTPUT_DIR}"

# Make output directory if it does not exist
if ! [[ -d $OUTPUT_DIR ]]; then
    echo -n "Output directory does not exist. Attempting to create... "
    mkdir $OUTPUT_DIR
    if [[ $? != 0 ]]; then
        echo "failed."
        exit $UNABLE_TO_MAKE_OUTPUT_DIR;
    fi
fi

# Set up variables for running the clustering script. This is an example:
# $EXEC network.pairs network.jaccs network.clusters network.cluster_stats threshold
EXEC="${SCRIPTS_DIR}/${CLUST_SCRIPT}"

for thr in 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1
do
    echo "Threshold: ${thr}"
    $EXEC $PAIRS_FILE $JACCS_FILE \
        $OUTPUT_DIR/network_$thr.cluster \
        $OUTPUT_DIR/network_$thr.cluster_stats \
        $thr
done
