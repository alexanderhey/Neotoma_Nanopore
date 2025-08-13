library(vcfR)  
library(SNPfiltR)
library(reshape2)
library(ggplot2)


# Read the VCF file
vcf_file <- "all_samples_var_only_window_snps.raw.vcf.gz"
vcf <- read.vcfR(vcf_file)

matrix <- extract.gt(vcf, element = "DP")
colSums(matrix=="0/0", na.rm = T)

sample_ids <- colnames(vcf@gt)[-1]
print(sample_ids)


# Create a popmap data frame
# Here, we arbitrarily assign populations for the example. 
# Replace this with your actual population assignments.
#popmap <- data.frame(
# id = sample_ids,
#pop = rep(c("Mexico LEU", "Hamilton LEU", "El Paso LEU", "Aetna ??", "Lawrence FLO", "Hamilton Micro (from aetna)", "Hamilton FLO", "Texas Micro", "Hamilton Micro"), length.out = length(sample_ids)),
#stringsAsFactors = FALSE
#)
population_names <- c("Douglas FL", "Ham MI", "Aetna MI", "ElPaso LEU", "Ham LEU", "Mexico LEU","Ham FLO", "Ham Mic", "Texas MIC")


# Define the population names in the correct order
#population_names <- c("Texas Mic", "Mexico Leu", "Aetna MI", "Ham Mic", "Ham LEU", "Ham mic 2976","Douglas FLO", "Ham FLO", "El Paso Leu")

# Create the popmap
popmap <- data.frame(
  id = sample_ids,
  pop = population_names,
  stringsAsFactors = FALSE
)

# Print the popmap to check
print(popmap)

#filter without a depth of 3
vcff <- hard_filter(vcf, depth = 3)

#execute allele balance filter
vcff<-filter_allele_balance(vcff)

#SNP depth
vcff<-max_depth(vcff, maxdepth = 100)

#filter biallelic sites 
vcfb <- filter_biallelic(vcff)

#run function to visualize samples
missing_by_sample(vcfR=vcfb, popmap = popmap)

#filter for only SNPs retained within X samples
vcf_filt <- missing_by_snp(vcfb, cutoff = 0.7)


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


write.vcf(vcf_filt_minmac2, "minmac2_allruns.vcf.gz")





vcf_dist_filt <- distance_thin(vcf_filt_minmac2, min.distance = 100)
# Check the number of SNPs and individuals in the filtered VCF
num_snps <- nrow(vcf_dist_filt@fix)
num_individuals <- ncol(vcf_dist_filt@gt) - 1 # Subtract 1 for the 'FORMAT' column

cat("Number of SNPs:", num_snps, "\n")
cat("Number of individuals:", num_individuals, "\n")
#Run PCA
pca_results <- assess_missing_data_pca(vcfR = vcf_dist_filt, popmap = popmap, clustering = F)



#I want one SNP per window. After this, I want to extract the widows in the BED file and then call SNPs and invariant sites on only those windows
vcf_dist_filt_win <- distance_thin(vcf, min.distance = 40000)
# Check the number of SNPs and individuals in the filtered VCF
num_snps <- nrow(vcf_dist_filt_win@fix)
num_individuals <- ncol(vcf_dist_filt_win@gt) - 1 # Subtract 1 for the 'FORMAT' column

cat("Number of SNPs:", num_snps, "\n")
cat("Number of individuals:", num_individuals, "\n")
#Run PCA
pca_results <- assess_missing_data_pca(vcfR = vcf_dist_filt_win, popmap = popmap, clustering = F)

write.vcf(vcf_filt_minmac2, "minmac2_1SNPperWindow.vcf.gz")

# Extract the fixed data from the vcfR object
fixed_data <- getFIX(vcf_dist_filt_win)

# Extract the CHROM and POS columns
chrom_pos <- fixed_data[, c("CHROM", "POS")]

# Convert the POS column to numeric
chrom_pos[, "POS"] <- as.numeric(chrom_pos[, "POS"])

# Print the resulting data frame
print(chrom_pos)
# Load necessary library
library(dplyr)

# Read the BED file
bed_file <- read.table("filtered_40kb_loci_fixed.bed", header = FALSE, col.names = c("CHROM", "START", "END"))

# Convert CHROM and POS (from chrom_pos) into a data frame
chrom_pos_df <- as.data.frame(chrom_pos)
colnames(chrom_pos_df) <- c("CHROM", "POS")

# Find the matching windows for each SNP position
matched_windows <- bed_file %>%
  filter(rowSums(
    mapply(function(chrom, pos) (CHROM == chrom & START <= pos & END >= pos),
           chrom_pos_df$CHROM, chrom_pos_df$POS)
  ) > 0)

# Save the matching windows to a new BED file
write.table(matched_windows, file = "windows_for_tree.bed", row.names = FALSE, col.names = FALSE, sep = "\t", quote = FALSE)








# Extract the PCA data and sample IDs
pca_df <- data.frame(
  PC1 = pca_results$PC1,  # First principal component
  PC2 = pca_results$PC2,  # Second principal component
  Sample = rownames(pca_results)  # Sample IDs
)

# Create a PCA plot with sample IDs as labels
pca_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, label = Sample)) +
  geom_point(size = 3) +
  geom_text(vjust = -0.5) +  # This adds the sample labels
  labs(title = "PCA of Filtered VCF", x = "Principal Component 1", y = "Principal Component 2") +
  theme_minimal()

# Print the PCA plot
print(pca_plot)





write.vcf(vcf_filt, "allrunz_filtered.vcf.gz





