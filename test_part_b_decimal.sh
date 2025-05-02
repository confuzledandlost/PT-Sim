#!/bin/bash

echo "=== Testing PT-Sim-Clock Part B (Decimal Output) ==="
echo "Input: test_input1.txt, Expected Output: test_PT_A_output2_dec.txt"
echo

# Run the page table simulator with clock algorithm and capture output
output=$(./pt-sim-clock.sh tests/PT_A.txt < tests/test_input1.txt)

# Print the output
echo -e "=== Actual Output ===\n$output\n"

# Compare with expected output
expected_file="tests/expected_output/test_PT_A_output2_dec.txt"
echo -e "=== Expected Output ===\n$(cat $expected_file)\n"

# Create a temporary file with the output
temp_file=$(mktemp)
echo "$output" > "$temp_file"

# Compare using diff
echo "=== Diff (empty means no differences) ==="
diff "$temp_file" "$expected_file"

# Clean up
rm "$temp_file" 