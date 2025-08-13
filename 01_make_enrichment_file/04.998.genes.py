#! /usr/bin/env python3

import random

def select_random_lines(input_file, output_file, num_lines=998):
    # Read all lines from input file
    with open(input_file, 'r') as f:
        lines = f.readlines()
    
    # Randomly select num_lines
    selected_lines = random.sample(lines, min(num_lines, len(lines)))
    
    # Sort selected lines by first and second columns
    selected_lines.sort(key=lambda x: (x.split('\t')[0], int(x.split('\t')[1])))
    
    # Write selected lines to output file
    with open(output_file, 'w') as f:
        f.writelines(selected_lines)
        
# Usage example
input_file = 'spaced_genes.txt'
output_file = '998_genes.txt'
select_random_lines(input_file, output_file)

