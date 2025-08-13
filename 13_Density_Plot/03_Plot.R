library(ggplot2)
library(scales)
library(dplyr)

#Samples with their file paths. InFile is counts inside windows and OutFile is those without
samples <- data.frame(
  Sample = c("ASK15335", "FN1560", "FN2395", "FN2976", "FN2980", "FN2989", 
             "FN3258", "MSB:Mamm:274024", "NK305240"),
  InFile = c("sorted_ASK15335_aligned_in_windows_lengths.tsv",
             "sorted_FN1560_aligned_in_windows_lengths.tsv",
             "sorted_FN2395_aligned_ind_sup_in_windows_lengths.tsv",
             "sorted_FN2976_aligned_in_windows_lengths.tsv",
             "sorted_FN2980_aligned_in_windows_lengths.tsv",
             "sorted_FN2989_aligned_ind_sup_in_windows_lengths.tsv",
             "sorted_FN3258_ind_sup_in_windows_lengths.tsv",
             "sorted_MSB274024_aligned_in_windows_lengths.tsv",
             "sorted_NK305240_aligned_in_windows_lengths.tsv"),
  OutFile = c("sorted_ASK15335_aligned_out_windows_lengths.tsv",
              "sorted_FN1560_aligned_out_windows_lengths.tsv",
              "sorted_FN2395_aligned_ind_sup_out_windows_lengths.tsv",
              "sorted_FN2976_aligned_out_windows_lengths.tsv",
              "sorted_FN2980_aligned_out_windows_lengths.tsv",
              "sorted_FN2989_aligned_ind_sup_out_windows_lengths.tsv",
              "sorted_FN3258_ind_sup_out_windows_lengths.tsv",
              "sorted_MSB274024_aligned_out_windows_lengths.tsv",
              "sorted_NK305240_aligned_out_windows_lengths.tsv"),
  stringsAsFactors = FALSE
)
#Initialize data frame to store all combined data
combined_data <- data.frame()

#Process and combine data for each sample. For each read length, how many reads of that length are there?
for (i in 1:nrow(samples)) {
  df_in <- read.delim(samples$InFile[i], header = FALSE, col.names = c("ReadLength", "Count"))
  df_out <- read.delim(samples$OutFile[i], header = FALSE, col.names = c("ReadLength", "Count"))
  
  #no reads under 10bp
  df_in <- df_in[df_in$ReadLength >= 10, ]
  df_out <- df_out[df_out$ReadLength >= 10, ]
  
  #Expand the count data back to individual read lengths
  expanded_in <- rep(df_in$ReadLength, df_in$Count)
  expanded_out <- rep(df_out$ReadLength, df_out$Count)
  
  #Create a data frame for this sample with all individual read lengths
  sample_data <- data.frame(
    ReadLength = c(expanded_in, expanded_out),  #Combine inside and outside read lengths
    Source = rep(c("Inside Windows", "Outside Windows"),  #Label each read's source
                 c(length(expanded_in), length(expanded_out))),  
    Sample = samples$Sample[i]  #Add sample identifier to each row
  )
  
  #Add to  master data frame
  combined_data <- bind_rows(combined_data, sample_data)
}

#plot
p <- ggplot(combined_data, aes(x = ReadLength, color = Source)) +
  #density curves for read length distributions
  geom_density(size = 1, adjust = 0.5) +  
  #Use logarithmic scale for x-axis with comma formatting
  scale_x_log10(labels = comma) +
  #Use logarithmic scale for y-axis (density)
  scale_y_log10() +
  #Add vertical reference line for decision
  geom_vline(aes(xintercept = 400, color = "400 bp Reference"),
             linetype = "dashed", size = 1, show.legend = TRUE) +
  #Create separate panels for each sample (3 columns)
  facet_wrap(~ Sample, ncol = 3) +
  #Use minimal theme with larger text
  theme_minimal(base_size = 14) +
  #Set axis labels and remove color legend title
  labs(x = "Read Length (log scale)",
       y = "Density (log scale)",
       color = "") +
  #Customize plot
  theme(strip.text = element_text(face = "bold"),    
        legend.position = "top",                      
        panel.grid.major = element_line(color = "gray90")) +  
  #set colors
  scale_color_manual(values = c("Inside Windows" = "blue",
                                "Outside Windows" = "orange",
                                "400 bp Reference" = "red"))

#Save the plot
ggsave("Combined_ReadLengthDistributions.pdf", plot = p, width = 30, height = 12)