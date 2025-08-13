# Load necessary libraries
library(vcfR)
library(adegenet)
library(ggplot2)
library(StAMPP)
library(reshape2)

# Define VCF file
vcf_file <- "thebestvcf_nomissing_depth5_100distfilt_minmac2.vcf.gz"

# Read VCF file
vcf <- read.vcfR(vcf_file)

# Convert VCF to genlight object
gen <- vcfR2genlight(vcf)


# Define the current order of rows
current_order <- seq_len(nrow(gen))

# Define the desired order
#desired_order <- c("FN2395", "FN2989", "FN3258", "FN2976", "FN2980", 
#                  "NK305240", "FN1560", "ASK15335", "MSB274024")
# Extract the current individual names
current_labels <- indNames(gen)

# Function to extract only the ID from each label
extract_id <- function(label) {
  sub("^sorted_([^_]+)_.*", "\\1", label)
}

# Apply the function to clean the labels
new_labels <- sapply(current_labels, extract_id, USE.NAMES = FALSE)

# Update the individual names in the genlight object
indNames(gen) <- new_labels

# Check the updated names
print(indNames(gen))


# Define the population names in the correct order
population_names <- c("Douglas Co FLO", "Hamilton Micro", "Aetna Micro",  "El Paso LEU", "Hamilton Leu", "Mexico Leu", "Hamilton FLO", "Hamilton Mic", "Texas Micro")

# Create the popmap
popmap <- data.frame(
  id = colnames(vcf@gt)[-1],  # Extract sample IDs from VCF
  pop = population_names,
  stringsAsFactors = FALSE
)

# Print the popmap to check
print(popmap)

# Clean the IDs in popmap to match genlight names
popmap$id_clean <- sapply(popmap$id, extract_id, USE.NAMES = FALSE)

# Confirm they now match
setdiff(indNames(gen), popmap$id_clean)  # Should return character(0)

# Assign populations using the cleaned IDs
pop(gen) <- popmap$pop[match(indNames(gen), popmap$id_clean)]


# Calculate Nei's genetic distances between individuals
sample.div <- stamppNeisD(gen, pop = FALSE)

# Export genetic distance matrix for SplitsTree
stamppPhylip(distance.mat = sample.div, file = "splits_tree_distance_matrix_thebestvcf.txt")

cat("Genetic distance matrix saved as splits_tree_distance_matrix.txt")

#go check your row names now dummy