#!/bin/bash

awk -F'\t' '$3 == "gene"' Neotoma_lepida.Chromosomes_only_annotations.gff3 > Neotoma_lepida.Chromosomes_genes.gff3

