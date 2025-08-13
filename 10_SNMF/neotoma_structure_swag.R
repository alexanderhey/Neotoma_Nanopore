## Install Bioconductor if you don't already have it. 
source("http://bioconductor.org/biocLite.R")
biocLite()

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("LEA")

## Install dependencies for other stuff like plotting piecharts on map
#install.packages(c("fields","RColorBrewer","mapplots"))


library(LEA)
## Load functions to import input files from STRUCTURE format and display ancestry coefficients on map
source("http://membres-timc.imag.fr/Olivier.Francois/Conversion.R")
source("http://membres-timc.imag.fr/Olivier.Francois/POPSutilities.R")

## Convert .str file. Format=2 if individual samples are in 2 lines. 
# TESS=FALSE if no geographic data in matrix
# extra.col=2 if you have population data in second colum
#we deleted the first row of our str file as extra. rows was not working 


#Read the .str file (assuming no header)
str_data <- read.table("minmac2_allruns_windowsonly.str", header = FALSE)

# Define the current order of rows
current_order <- seq_len(nrow(str_data))

# Define the desired order
#desired_order <- c("FN2395", "FN2989", "FN3258", "FN2976", "FN2980", 
 #                  "NK305240", "FN1560", "ASK15335", "MSB274024")

# Function to extract only the ID from labels
extract_id <- function(label) {
  sub("^sorted_([^_]+)_.*", "\\1", label)
}

# Extract IDs from the first column
current_labels <- sapply(str_data[, 1], extract_id, USE.NAMES = FALSE)



# Extract and print the unique cleaned labels
unique_labels <- unique(str_data[, 1])
new_labels <- sapply(unique_labels, extract_id, USE.NAMES = FALSE)

print(new_labels)  # Should output the desired order


unique_labels <- new_labels


## Convert .str file. Format=2 if individual samples are in 2 lines. 
# TESS=FALSE if no geographic data in matrix
# extra.col=2 if you have population data in second colum
#we deleted the first row of our str file as extra. rows was not working 


struct2geno(file="minmac2_allruns_windowsonly.str", TESS=F, diploid=TRUE, FORMAT=2, extra.col=1, output = "gwg_windowsnps.geno", extra.row = 0 )




##################
###### SNMF ######
##################

## Choose number of K's and reps
all <- snmf("gwg_windowsnps.geno", K=1:10, ploidy = 2, entropy = T, rep=100, CPU=12, project = "new")

#if you need to load it after running
#all <- load.snmfProject("gwg_noprocess_thebestvcf.snmfProject")
## Plot cross-entropy values of all runs 
plot(all, col = "blue4", cex = 1.4, pch = 19)

## Select K with lowest cross-entropy value
## Get the cross-entropy value of each run for best K

## Determine run with the lowest cross-entropy based on chosen K
best <- which.min(cross.entropy(all, K=3))

## Choose colors
#display.brewer.all(n=NULL, type="all", select=NULL, exact.n=TRUE, colorblindFriendly=FALSE)
colourCount = 3 #number of unique colors

## Plot the best run for the best K 
#mycol <- brewer.pal(13, type="div")
#mycol <- c("orange","dodgerblue","red","chartreuse","darkorchid")
qmatrix.all <- Q(all, K=3, run=best) ## make matrix of ancestry coefficients using best K and best run for that K


## Use colorRampPalette to extrapolate more colors
barplot(t(qmatrix.all), col = colorRampPalette(brewer.pal(8, "Accent"))(colourCount), 
        border = T, space = 0, xlab = "Individuals", ylab = "Admixture coefficients")

#barplot with labels
barplot(
  t(qmatrix.all), 
  col = colorRampPalette(brewer.pal(8, "Accent"))(colourCount), 
  border = TRUE, 
  space = 0, 
  xlab = "Individuals", 
  ylab = "Admixture coefficients",
  names.arg = unique_labels,  # Add unique labels
  cex.names = 0.7,  # Adjust text size if needed
  las = 1  # Make labels horizontal
)






#reorder things to match adobe illustrator figure
library(dplyr)
library(ggplot2)
library(reshape2)# Assuming qmatrix.all is already correctly ordered as per your first part of the script
qmatrix_df <- as.data.frame(qmatrix.all)
unique_labels <- as.character(unique_labels)  # Ensure labels are characters for matching

# Define the desired order of individuals
desired_order <- c("FN2395", "FN1560", "FN3258", "FN2976", "FN2989", "NK305240", "FN2980", "ASK15335", "MSB274024")

# Ensure all desired_order elements are in unique_labels
if(!all(desired_order %in% unique_labels)) {
  stop("One or more labels in the desired order are not present in unique_labels")
}

# Set factor levels to desired order directly
qmatrix_df$Individual <- factor(unique_labels, levels = desired_order)

# Reshape the data for ggplot2
qmatrix_melt <- reshape2::melt(qmatrix_df, id.vars = "Individual")

# Create the plot
library(ggplot2)
ggplot(qmatrix_melt, aes(x = Individual, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "stack") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 18, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 18),
    axis.title.x = element_text(size = 20),
    axis.title.y = element_text(size = 20),
    legend.text = element_text(size = 16),
    legend.title = element_text(size = 18)
  ) +
  labs(x = "Individuals", y = "Admixture coefficients") +
  scale_fill_brewer(palette = "Accent")


##########################################################
#plotting multiple values of K in a desired order
library(LEA)
library(RColorBrewer)
library(ggplot2)
library(reshape2)
library(dplyr)

# Choose K values you want to plot
K_values <- 2:5

# Initialize a list to store dataframes for each K
qmatrix_list <- list()

# Loop through each K
for (K in K_values) {
  best_run <- which.min(cross.entropy(all, K = K))
  qmatrix <- Q(all, K = K, run = best_run)
  
  # Convert to dataframe and add Individual and K info
  qmatrix_df <- as.data.frame(qmatrix)
  qmatrix_df$Individual <- unique_labels  # ensure unique_labels is already defined in your env
  qmatrix_df$K <- paste0("K=", K)  # Add K label
  
  # Melt the dataframe
  qmatrix_melt <- melt(qmatrix_df, id.vars = c("Individual", "K"))
  
  # Store
  qmatrix_list[[as.character(K)]] <- qmatrix_melt
}

# Combine all into one dataframe
all_qmatrix_melt <- bind_rows(qmatrix_list)

# Set factor levels for Individuals to ensure consistent order
desired_order <- c("FN2395", "FN1560", "FN3258", "FN2976", "FN2989", "NK305240", "FN2980", "ASK15335", "MSB274024")
all_qmatrix_melt$Individual <- factor(all_qmatrix_melt$Individual, levels = desired_order)

# Add a numeric Y to know where to position the K label (e.g., mid-way)
all_qmatrix_melt$K_numeric <- as.numeric(gsub("K=", "", all_qmatrix_melt$K))

# Create the plot
ggplot(all_qmatrix_melt, aes(x = Individual, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "stack", width = .99) +
  facet_wrap(~K, ncol = 1, strip.position = "bottom") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 14, angle = 45, hjust = 1),
    axis.text.y = element_blank(),  # Remove y-axis ticks
    axis.title.y = element_blank(),  # Remove y-axis title
    axis.title.x = element_blank(),  # Remove x-axis title
    panel.grid.major.y = element_blank(),  # Clean up grid
    panel.grid.minor.y = element_blank(),
    strip.text.x = element_blank(),  # Remove facet labels
    panel.spacing = unit(0.0, "lines")  # Add space between facets
  ) +
  geom_text(
    data = . %>% group_by(K) %>% summarize(),  # one label per facet
    aes(x = -0.5, y = 0.5, label = K),
    inherit.aes = FALSE,
    size = 6,
    hjust = 0
  ) +
  scale_fill_brewer(palette = "Accent") +
  labs(fill = "Cluster")

ggsave("admixture_plot_thebestvcf.pdf", width = 8, height = 10)

