#!/bin/bash

echo "=== Testing PT-Sim Part A (Decimal Output) ==="
echo "Input: test_input1.txt, Expected Output: test_PT_A_output1_dec.txt"
echo

# Run the page table simulator and capture output
output=$(./pt-sim.sh tests/PT_A.txt < tests/test_input1.txt)

# Print the output
echo -e "=== Actual Output ===\n$output\n"

# Compare with expected output
expected_file="tests/expected_output/test_PT_A_output1_dec.txt"
echo -e "=== Expected Output ===\n$(cat $expected_file)\n"

# Create temporary files with exact content (including specific line endings)
temp_actual=$(mktemp)
temp_expected=$(mktemp)

# Make sure output has the exact same format
echo "$output" | tr -d '\n' > "$temp_actual" 
cat "$expected_file" | tr -d '\n' > "$temp_expected"

# Compare using cmp for byte-by-byte comparison
echo "=== Binary comparison (empty means identical) ==="
if cmp -s "$temp_actual" "$temp_expected"; then
    echo -e "SUCCESS: Files are identical"
    exit_code=0
else
    echo -e "FAILURE: Files differ"
    # Show diff for debugging
    diff "$temp_actual" "$temp_expected"
    exit_code=1
fi

# Clean up
rm "$temp_actual" "$temp_expected"

exit $exit_code 