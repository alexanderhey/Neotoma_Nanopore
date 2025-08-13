
# Load required modules
module load muscle
module load iqtree/2.3.6


# Paths to input and output files
INPUT_FASTA="/kuhpc/work/colella/a733h002/neotoma/MITOGENOME_ALIGN_FORALL/alignment/cytb_sequences_all.fasta"
ALIGNED_FASTA="/kuhpc/work/colella/a733h002/neotoma/MITOGENOME_ALIGN_FORALL/alignment/cytb_aligned.fasta"
TREE_OUTPUT_DIR="/kuhpc/work/colella/a733h002/neotoma/MITOGENOME_ALIGN_FORALL/alignment_cytb"

# Step 1: Align the sequences with MUSCLE
# Following the correct MUSCLE 5.3 command syntax
echo "Aligning sequences with MUSCLE..."
muscle -align "$INPUT_FASTA" -output "$ALIGNED_FASTA"


# Step 2: Build a phylogenetic tree with IQ-TREE2
echo "Building a phylogenetic tree with IQ-TREE2..."
cd "$TREE_OUTPUT_DIR"
iqtree2 -s "$ALIGNED_FASTA" -m MFP -st DNA -bb 1000 -alrt 1000 -nt AUTO -pre "${TREE_OUTPUT_DIR}/cytb_tree"

# -s    : Specifies the input alignment file (FASTA, PHYLIP, NEXUS, etc.)
# -m    : Model selection using ModelFinder Plus (MFP) to automatically select the best-fit model
# -st   : Specifies the sequence type (DNA, AA for amino acids, or CODON)
# -bb   : Ultrafast bootstrap with 1000 replicates for branch support
# -alrt : Approximate Likelihood Ratio Test (aLRT) with 1000 replicates for branch support
# -nt   : Number of CPU threads to use, AUTO lets IQ-TREE determine the optimal number
# -pre  : Specifies the prefix for output files (log, tree, model details, etc.)
echo "Alignment and tree building completed successfully."
