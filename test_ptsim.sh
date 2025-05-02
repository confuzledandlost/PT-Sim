#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Run Part A test with decimal output
echo "=== Running Part A test with decimal output ==="
output_dec=$(./pt-sim.sh tests/PT_A.txt < tests/test_input1.txt)

# Create a temporary file with the output
temp_file_dec=$(mktemp)
echo "$output_dec" > "$temp_file_dec"

# Compare with expected output
expected_file_dec="tests/expected_output/test_PT_A_output1_dec.txt"
if ! diff "$temp_file_dec" "$expected_file_dec" > /dev/null; then
    echo -e "${RED}FAILURE: Decimal output test failed!${NC}"
    exit 1
else
    echo -e "${GREEN}Decimal output test passed.${NC}"
fi

# Run Part A test with hex output
echo -e "\n=== Running Part A test with hex output ==="
output_hex=$(./pt-sim.sh tests/PT_A.txt --hex < tests/test_input1.txt)

# Create a temporary file with the output
temp_file_hex=$(mktemp)
echo "$output_hex" > "$temp_file_hex"

# Compare with expected output
expected_file_hex="tests/expected_output/test_PT_A_output1_hex.txt"
if ! diff "$temp_file_hex" "$expected_file_hex" > /dev/null; then
    echo -e "${RED}FAILURE: Hex output test failed!${NC}"
    exit 1
else
    echo -e "${GREEN}Hex output test passed.${NC}"
fi

# Clean up
rm "$temp_file_dec" "$temp_file_hex"

# If we got here, all tests passed
echo -e "\n${GREEN}SUCCESS: All Part A tests passed!${NC}" 