#!/bin/bash

# Calculate per-base depth for all BAM files in current directory

for bam in *.bam; do
    if [ -f "$bam" ]; then
        echo "Processing $bam..."
        samtools depth -a "$bam" > "${bam%.bam}_depth.txt"
    fi
done

# Generate average coverage summary
echo "Sample\tAverage_Coverage" > average_coverage_summary.txt

for depth_file in *_depth.txt; do
    if [ -f "$depth_file" ]; then
        sample_name=$(basename "$depth_file" _depth.txt)
        avg_coverage=$(awk '{sum+=$3; count++} END {print sum/count}' "$depth_file")
        echo -e "$sample_name\t$avg_coverage" >> average_coverage_summary.txt
    fi
done

echo "Done"