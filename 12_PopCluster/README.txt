# PopCluster Analysis

Parameters used in PoCluster (https://onlinelibrary.wiley.com/doi/abs/10.1111/1755-0998.14058) for admixture coefficient generation

## Dataset
- **Samples**: 9 individuals
- **Loci**: 4,572 SNPs
- **Format**: 1 row per individual
- **Missing data**: . (period)

## Settings
- **K range**: 1-9 (10 runs each)
- **Model**: Admixture with unknown allele frequency priors
- **Relatedness**: Wang estimator
- **Search**: Assignment probability method
- **Scaling**: Medium likelihood scaling

## Key Parameters
- All loci treated as SNPs
- Allele frequencies estimated from data
- Locus admixture and Fst estimation enabled
- No kinship inference or population priors used

## Outputs
Analysis produces population assignments, admixture coefficients, and Fst estimates for K=1-9.