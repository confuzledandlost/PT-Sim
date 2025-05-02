# PT-Sim shell script
# This script runs the page table simulator for Part A

# Run the Python implementation
python3 ptsim.py "$1"

# If it were a binary called pt-sim.x, just do
# ./pt-sim.x $1
# and it will read from stdin, as normal


