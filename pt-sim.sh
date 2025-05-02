# PT-Sim shell script
# This script runs the page table simulator for Part A

if [[ "$2" == "--hex" ]]; then
    python3 ptsim.py "$1" --hex
else
    python3 ptsim.py "$1"
fi

# If it were a binary called pt-sim.x, just do
# ./pt-sim.x $1
# and it will read from stdin, as normal


