#! /usr/bin/env python3

def filter_genes(input_file, output_file, min_distance=100000):
    genes_by_chromosome = {}
    
    # Read input file and group genes by chromosome
    with open(input_file, 'r') as f:
        for line in f:
            fields = line.strip().split('\t')
            chromosome = fields[0]
            start = int(fields[3])
            stop = int(fields[4])
            if chromosome not in genes_by_chromosome:
                genes_by_chromosome[chromosome] = []
            genes_by_chromosome[chromosome].append((chromosome, start, stop))
    
    # Filter genes for each chromosome
    filtered_genes = []
    for chromosome, genes in genes_by_chromosome.items():
        prev_stop = None
        for gene in genes:
            chromosome, start, stop = gene
            if prev_stop is None or start - prev_stop >= min_distance:
                filtered_genes.append(gene)
                prev_stop = stop
    
    # Write filtered genes to output file
    with open(output_file, 'w') as f:
        for gene in filtered_genes:
            f.write('\t'.join(map(str, gene)) + '\n')

# Usage example
input_file = 'Neotoma_lepida.Chromosomes_genes.gff3'
output_file = 'spaced_genes.txt'
filter_genes(input_file, output_file)
