# R script to download selected samples
# Copy code and run on a local machine to initiate download

# Check for dependencies and install if missing
packages <- c("rhdf5","pkgconfig")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  BiocManager::install("rhdf5")
}
#make ~/.R/Makevars  and add the following (remove # in the beginning of each line)
# LDFLAGS= -L/usr/local/clang4/lib
# FLIBS=-L/usr/local/gfortran/lib/gcc/x86_64-apple-darwin16/6.3.0 -L/usr/local/gfortran/lib -lgfortran -lquadmath -lm
# CC=/usr/local/clang4/bin/clang
# CXX=/usr/local/gfortran/bin/g++
#   CXX1X=/usr/local/gfortran/bin/g++
#   CXX98=/usr/local/gfortran/bin/g++
#   CXX11=/usr/local/gfortran/bin/g++
#   CXX14=/usr/local/gfortran/bin/g++
#   CXX17=/usr/local/gfortran/bin/g++
#   
#   LLVM_LOC = /usr/local/opt/llvm
# CC=/usr/local/gfortran/bin/gcc -fopenmp
# CXX=/usr/local/gfortran/bin/g++ -fopenmp
# # -O3 should be faster than -O2 (default) level optimisation ..
# CFLAGS=-g -O3 -Wall -pedantic -std=gnu99 -mtune=native -pipe
# CXXFLAGS=-g -O3 -Wall -pedantic -std=c++11 -mtune=native -pipe
# LDFLAGS=-L/usr/local/opt/gettext/lib -L$(LLVM_LOC)/lib -Wl,-rpath,$(LLVM_LOC)/lib
# CPPFLAGS=-I/usr/local/opt/gettext/include -I$(LLVM_LOC)/include -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include

#add this path to your mac:  /usr/local/gfortran/bin





if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")


library("rhdf5")
library("tools")

setwd("~/Dropbox (Gladstone)/Pathway-Project/human_matrix_download.h5")
destination_file = "human_matrix_download.h5"
extracted_expression_file = "Hair Follicle_expression_matrix.tsv"
#url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix.h5"
# Check if gene expression file was already downloaded and check integrity, if not in current directory download file form repository
# if(!file.exists(destination_file)){
#   print("Downloading compressed gene expression matrix.")
#   download.file(url, destination_file, quiet = FALSE)
# }

# Selected samples to be extracted
samp = c("GSM2072459","GSM2072458","GSM2703811","GSM2703812","GSM2703813","GSM2703814","GSM2703815","GSM2703816","GSM3717034","GSM3717035","GSM3717036","GSM3717037","GSM3717038","GSM3731086","GSM3731087","GSM3731088","GSM3731089","GSM3731090","GSM3731091","GSM3731092","GSM3731093","GSM3731094","")

# Retrieve information from compressed data
samples = h5read(destination_file, "meta/Sample_geo_accession")
tissue = h5read(destination_file, "meta/Sample_source_name_ch1")
genes = h5read(destination_file, "meta/genes")
data = h5read(destination_file, "meta")
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
