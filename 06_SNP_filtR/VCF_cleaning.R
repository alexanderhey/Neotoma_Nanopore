library(vcfR)  
library(SNPfiltR)
library(reshape2)
library(ggplot2)

# Read the VCF file
vcf_file <- "step3_mac2.vcf.gz"
vcf <- read.vcfR(vcf_file)

matrix <- extract.gt(vcf, element = "DP")
colSums(matrix=="0/0", na.rm = T)

sample_ids <- colnames(vcf@gt)[-1]
print(sample_ids)


# Define the population names in the correct order
population_names <- c("Douglas Co FLO", "Hamilton Mic", "Aetna Micro", "El Paso LEU","Hamilton Leu", "Mexico Leu", "Hamilton FLO", "Hamilton Micro", "Texas Micro")

# Create the popmap
popmap <- data.frame(
  id = sample_ids,
  pop = population_names,
  stringsAsFactors = FALSE
)

# Print the popmap to check
print(popmap)


#quick PCA if you don't want to filter that thang
pca_results <- assess_missing_data_pca(vcfR = vcf, popmap = popmap, clustering = F)



#filter without a depth of 3
vcff <- hard_filter(vcf, depth = 5)

#execute allele balance filter
vcff<-filter_allele_balance(vcff)


#SNP depth
vcff<-max_depth(vcff, maxdepth = 100)
 
# Check the number of SNPs and individuals in the filtered VCF
num_snps <- nrow(vcf_filt@fix)
num_individuals <- ncol(vcf_filt@gt) - 1 # Subtract 1 for the 'FORMAT' column

cat("Number of SNPs:", num_snps, "\n")
cat("Number of individuals:", num_individuals, "\n")

#get rid of invariant sites 
vcf_filt_minmac <- min_mac(vcf_filt, min.mac = 1)


# Check the number of SNPs and individuals in the filtered VCF
num_snps <- nrow(vcf_filt_minmac@fix)
num_individuals <- ncol(vcf_filt_minmac@gt) - 1 # Subtract 1 for the 'FORMAT' column

cat("Number of SNPs:", num_snps, "\n")
cat("Number of individuals:", num_individuals, "\n")

#visualize 
pca_results <- assess_missing_data_pca(vcfR = vcf_filt_minmac, popmap = popmap, clustering = F)


write.vcf(vcf_filt_minmac, "minmac1.allruns.vcf.gz")


#get rid of singletons
vcf_filt_minmac2 <- min_mac(vcf_filt, min.mac = 2)

# Check the number of SNPs and individuals in the filtered VCF
num_snps <- nrow(vcf_filt_minmac2@fix)
num_individuals <- ncol(vcf_filt_minmac2@gt) - 1 # Subtract 1 for the 'FORMAT' column

cat("Number of SNPs:", num_snps, "\n")
cat("Number of individuals:", num_individuals, "\n")

#visualize 
pca_results <- assess_missing_data_pca(vcfR = vcf_filt_minmac2, popmap = popmap, clustering = F)


vcf_dist_filt <- distance_thin(vcf_filt_minmac2, min.distance = 100)

# Check the number of SNPs and individuals in the filtered VCF
num_snps <- nrow(vcf_dist_filt@fix)
num_individuals <- ncol(vcf_dist_filt@gt) - 1 # Subtract 1 for the 'FORMAT' column

cat("Number of SNPs:", num_snps, "\n")
cat("Number of individuals:", num_individuals, "\n")
#Run PCA
pca_results <- assess_missing_data_pca(vcfR = vcf_dist_filt, popmap = popmap, clustering = F)
write.vcf(vcf_dist_filt, "nomissing_depth5_100distfilt_minmac2.vcf.gz")


