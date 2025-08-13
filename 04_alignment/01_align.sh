
#!/bin/bash
# 01_align.sh
# Aligns basecalled Nanopore reads to reference genome using Dorado

# Path to Dorado executable (UPDATE THIS PATH)
dorado_path="path/to/dorado/bin/dorado"

# Path to reference genome (UPDATE THIS PATH)
reference="path/to/reference_genome.fasta"

# Path to basecalled BAM file (UPDATE THIS PATH)
input_bam="path/to/basecalled_reads.bam"

# Output aligned BAM file name (UPDATE THIS NAME)
output_bam="sample_aligned.bam"

# Run Dorado alignment
echo "Starting alignment..."
$dorado_path aligner $reference $input_bam > $output_bam

if [ $? -eq 0 ]; then
    echo "Alignment completed successfully: $output_bam"
else
    echo "Alignment failed"
    exit 1
fi