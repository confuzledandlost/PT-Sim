#!/bin/bash
# PT-Sim-Clock shell script
# This script runs the page table simulator for Part B with Clock algorithm

# Check for hex flag
if [[ "$2" == "--hex" ]]; then
    python3 ptsim.py "$1" --clock --hex
else
    python3 ptsim.py "$1" --clock
fi
