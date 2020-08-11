# R script to download selected samples
# Copy code and run on a local machine to initiate download

# Check for dependencies and install if missing
packages <- c("rhdf5")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
    print("Install required packages")
    source("https://bioconductor.org/biocLite.R")
    biocLite("rhdf5")
}
library("rhdf5")
library("tools")

destination_file = "human_matrix_download.h5"
extracted_expression_file = "Spinal Cord_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix.h5"

# Check if gene expression file was already downloaded and check integrity, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE)
}

# Selected samples to be extracted
samp = c("GSM1278470","GSM1278456","GSM1278464","GSM1278469","GSM1278455","GSM1278460","GSM1278472","GSM1278457","GSM1278468","GSM1278467","GSM1278462","GSM1278458","GSM1278466","GSM1278473","GSM1278459","GSM1278471","GSM1278463","GSM1278454","GSM1278465","GSM2072398","GSM2072399","GSM2071288","GSM2071287","GSM2229955","GSM2229957","GSM2229953","GSM2229907","GSM2229945","GSM2229920","GSM2229951","GSM2229905",
"GSM2229921","GSM2229911","GSM2229937","GSM2229917","GSM2229925","GSM2229923","GSM2229893","GSM2229941","GSM2229899","GSM2229931","GSM2229943","GSM2229949","GSM2229927","GSM2229929","GSM2229947","GSM2229935","GSM2229915","GSM2229939","GSM2229904","GSM2229909","GSM2229897","GSM2229913","GSM2229933","GSM2229895","GSM2870386","GSM2870387","GSM2870388","GSM2870389","GSM2870390","GSM2870391",
"GSM2870392","GSM2870393","GSM2870394","GSM3430897","GSM3430898","GSM3430899","")

# Retrieve information from compressed data
samples = h5read(destination_file, "meta/Sample_geo_accession")
tissue = h5read(destination_file, "meta/Sample_source_name_ch1")
genes = h5read(destination_file, "meta/genes")

# Identify columns to be extracted
sample_locations = which(samples %in% samp)

# extract gene expression from compressed data
expression = h5read(destination_file, "data/expression", index=list(1:length(genes), sample_locations))
H5close()
rownames(expression) = genes
colnames(expression) = samples[sample_locations]

# Print file
write.table(expression, file=extracted_expression_file, sep="\t", quote=FALSE)
print(paste0("Expression file was created at ", getwd(), "/", extracted_expression_file))

