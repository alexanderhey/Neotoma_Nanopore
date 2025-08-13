#! /usr/bin/env python3

def calculate_new_positions(input_file, output_file):
    # Open input file and output file
    with open(input_file, 'r') as fin, open(output_file, 'w') as fout:
        # Process each line in the input file
        for line in fin:
            # Split the line into columns
            columns = line.strip().split('\t')
            
            # Calculate the midpoint
            midpoint = (int(columns[1]) + int(columns[2])) // 2
            
            # Calculate new positions
            new_start = midpoint - 20000
            new_end = midpoint + 20000
            
            # Write new positions to output file
            fout.write(f"{columns[0]}\t{new_start}\t{new_end}\n")

# Usage example
input_file = '1000_genes.txt'
output_file = '40kb_loci.txt'
calculate_new_positions(input_file, output_file)


