library(vcfR)  

#we want to filter out VCF to include only one SNP at each loci in order to run structure later. 

#This script extracts the loci column from each script, chooses the first loci at each script, and filters the original VCF to include only the first SNP at each loci

vcf2str <- function(vcfR = NULL, popmap = NULL, filename = NULL, missing.character = -9) {
  
  # extract genotype matrix
  m <- extract.gt(vcfR)
  m <- t(m)
  
  # recode missing data
  m[is.na(m)] <- (paste0(missing.character, "/", missing.character))
  
  # get unique values in matrix
  snp.values <- names(table(m))
  if (!all(snp.values %in% c("-9/-9", "0/0", "0/1", "1/1"))) {
    stop("unexpected values in genotype matrix")
  }
  
  # put popmap in same order as rownames in genotype matrix
  pm <- popmap[order(match(popmap$id, colnames(m))),]
  if (!identical(rownames(m), pm$id)) {
    stop("the individuals in the popmap and genotype matrix cannot be put in the same order... are some missing?")
  }
  
  # add id and pop columns to matrix
  id <- paste0(pm$id, "/", pm$id)
  pop <- paste0(pm$pop, "/", pm$pop)
  int.pop <- pop
  # convert pop to integer
  int <- 2
  for (p in unique(pop)) {
    int.pop[int.pop==p] <- paste0(int, "/", int)
    int <- int + 1
  }
  
  m <- cbind(id, int.pop, m)
  
  # make new matrix in structure format
  n <- matrix(nrow = 0, ncol = ncol(m))
  colnames(n) <- colnames(m)
  
  # populate new matrix
  for(i in 1:nrow(m)) {
    allele1 <- sapply(strsplit(m[i,], "/"), '[', 1)
    n <- rbind(n, allele1)
    
    allele2 <- sapply(strsplit(m[i,], "/"), '[', 2)
    n <- rbind(n, allele2)
  }
  
  # rename columns for structure
  colnames(n) <- c(" ", " ", colnames(n)[-1:-2])
  
  # write file
  write.table(n, file = filename, append = F, quote = F, sep = "\t", col.names = T, row.names = F)
}


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

vcf2str(vcfR = vcf, popmap = popmap, filename = "minmac2_allruns_windowsonly.str" )


#delete top row before moving into strructure plot




