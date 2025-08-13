library(vcfR)  
library(SNPfiltR)
library(reshape2)
library(ggplot2)
library(gsheet)
library(adegenet)


# Read the VCF file
vcf_file <- "minmac2_allruns.vcf.gz"
vcf <- read.vcfR(vcf_file)


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

print(popmap)

# Convert to genlight object
gen <- vcfR2genlight(vcf)

# Run PCA
di.pca <- glPca(gen, nf = 6)

# Extract PCA scores
di.pca.scores <- as.data.frame(di.pca$scores)
rownames(di.pca.scores) <- sample_ids
di.pca.scores$pop <- popmap$pop

# Assign custom colors for populations (you can modify these as needed)
pop_colors <- c(
  "Douglas Co FLO" = "#332288",
  "Hamilton Mic" = "#88CCEE",
  "Aetna Micro" = "#44AA99",
  "El Paso LEU" = "#117733",
  "Hamilton Leu" = "#999933",
  "Mexico Leu" = "#DDCC77",
  "Hamilton FLO" = "#CC6677",
  "Hamilton Micro" = "#882255",
  "Texas Micro" = "#AA4499"
)

# PCA plot
ggplot(di.pca.scores, aes(x = PC1, y = PC2, colour = pop)) +
  geom_point(pch = 19, size = 4) +
  scale_color_manual(values = pop_colors) +
  xlab(paste0("PC1, ", round(100 * di.pca$eig[1] / sum(di.pca$eig), 2), "% variance explained")) +
  ylab(paste0("PC2, ", round(100 * di.pca$eig[2] / sum(di.pca$eig), 2), "% variance explained")) +
  theme_classic() +
  theme(legend.title = element_blank())

# Save plot
ggsave(file = "window_SNPs_PCA.pdf", 
       units = "in", width = 6, height = 4.5)
