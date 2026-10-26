#!/usr/bin/env bash
set -euo pipefail


# This script assumes :
    # 1. FASTQ file is exactly 4 lines per read
    # 2. The file immediately starts with the first read (no blank line or comments)
    # 3. This input is case sensitive (use ATGCT instead of atgct)
 
# Time
SECONDS=0

# Check arguments format
if [[ $# -ne 2 ]]; then
    echo "Error; the input argument is <input.fastq> <sequence>"
    exit 1
fi

# Assign arguments
input="$1"
pattern="$2"

# Check input file
if [[ ! -f "$input" ]]; then
    echo "Error: File not found: $input"
    exit 1
fi

# Count reads whose sequence line contains the pattern
# assign result of awk to variable matching_reads
# increase count if the sequence is found in the 2nd line (read) and found at least one matching pattern 

matching_reads=$(awk -v pattern="$pattern" '
    NR % 4 == 2 && index($0, pattern) > 0 {
        count++
}
END {
    print count+0
}
' "$input")

# Display result
echo "Reads containing '$pattern': $matching_reads"

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
