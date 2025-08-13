# BAM Processing Scripts

Scripts for splitting and analyzing BAM files from Neotoma nanopore sequencing runs.

## Scripts

### `split_bams_for_window_hits.sh`
Splits BAM files based on overlap with genomic windows using bedtools.

**Input**: 9 aligned BAM files from 4 sequencing runs
**Output**: Split BAM files (reads inside vs outside windows)
- `*_in_windows.bam` - reads overlapping with filtered 40kb loci
- `*_out_windows.bam` - reads outside window regions

### `02_split_bam_readlengths.sh`
Extracts read length distributions from processed BAM files.

**Input**: Split BAM files from previous step
**Output**: TSV files with read length counts (`*_lengths.tsv`)
- Format: ReadLength\tCount

## Dependencies
- bedtools
- samtools
