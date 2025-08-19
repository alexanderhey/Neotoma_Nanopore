# Dorado Basecalling Script

Performs super accurate basecalling from raw POD5 files using Dorado. Processes multiple barcoded samples in a single script loop.

## Requirements
- Dorado basecaller
- Raw POD5 files organized in barcode subdirectories
- Sufficient disk space for output BAM files
- The chemistry kit for you Nanopore run. This can be downloaded on the Dorado github

## Output
- High-accuracy basecalled BAM files for each barcode
- Automatic adapter/barcode removal
Noteably MinKNOW has released basecalling in their GUI, so that can be easier