#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Run Part A test
echo -e "${GREEN}=== Running Part A test ===${NC}"
output=$(./pt-sim.sh tests/PT_A.txt < tests/test_input1.txt)

# Create a temporary file with the output
temp_file=$(mktemp)
echo "$output" > "$temp_file"

# Decide which expected output file to use based on implementation
# The project spec allows either decimal or hex output format
if [[ "$output" == *"0x"* ]]; then
    # Hex output detected
    expected_file="tests/expected_output/test_PT_A_output1_hex.txt"
    echo -e "Detected ${GREEN}hex${NC} output format"
else
    # Decimal output
    expected_file="tests/expected_output/test_PT_A_output1_dec.txt"
    echo -e "Detected ${GREEN}decimal${NC} output format"
fi

echo -e "\n${GREEN}=== Comparing with expected output ===${NC}"
if diff "$temp_file" "$expected_file" > /dev/null; then
    echo -e "\n${GREEN}SUCCESS: Part A test passed!${NC}"
else
    echo -e "\n${RED}=== Diff showing differences ===${NC}"
    diff "$temp_file" "$expected_file"
    echo -e "\n${RED}FAILURE: Part A test failed!${NC}"
    exit 1
fi

# Clean up
rm "$temp_file" 