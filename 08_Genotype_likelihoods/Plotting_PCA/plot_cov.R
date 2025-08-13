# Load libraries
library(ggplot2)

# Define file paths
cov_path <- "pcangsd_minind9_mindepth9_output.cov"
bamlist_path <- "bamlist.txt"

# Load covariance matrix
cov_matrix <- as.matrix(read.table(cov_path))

# Eigen decomposition
eig <- eigen(cov_matrix)

# Load sample names from bamlist
bamlist <- readLines(bamlist_path)
sample_names <- basename(bamlist)         # gets the filename (e.g., FN2395.bam)
sample_names <- sub("\\.bam$", "", sample_names)  # removes ".bam"

# Create PCA data frame
pca_df <- data.frame(
  PC1 = eig$vectors[, 1],
  PC2 = eig$vectors[, 2],
  Sample = sample_names
)

# Plot PCA
ggplot(pca_df, aes(x = PC1, y = PC2, label = Sample)) +
  geom_point(size = 3) +
  geom_text(vjust = -1.1, size = 3) +
  xlab(paste0("PC1 (", round(100 * eig$values[1] / sum(eig$values), 1), "%)")) +
  ylab(paste0("PC2 (", round(100 * eig$values[2] / sum(eig$values), 1), "%)")) +
  theme_minimal() +
  ggtitle("")
