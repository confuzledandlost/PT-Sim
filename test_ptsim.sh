#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to run a test and check result
run_test() {
    test_script="$1"
    test_name="$2"
    
    echo -e "\n${GREEN}=== Running $test_name ===${NC}"
    
    # Run the test and capture exit code
    ./$test_script
    result=$?
    
    if [ $result -ne 0 ]; then
        echo -e "\n${RED}FAILURE: $test_name failed!${NC}"
        return 1
    else
        echo -e "\n${GREEN}$test_name passed.${NC}"
        return 0
    fi
}

# Initialize error counter
errors=0

# Run Part A test (decimal output)
run_test "test_part_a_decimal.sh" "Part A (Decimal Output)"
errors=$((errors + $?))

# Run Part B test (decimal output)
run_test "test_part_b_decimal.sh" "Part B (Decimal Output)"
errors=$((errors + $?))

# Final result
if [ $errors -eq 0 ]; then
    echo -e "\n${GREEN}SUCCESS: All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}FAILURE: $errors test(s) failed!${NC}"
    exit 1
fi 