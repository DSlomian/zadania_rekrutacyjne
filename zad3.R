library(vcfR)
vcf_file = read.vcfR(file.choose(), verbose = FALSE)
head(vcf_file)
w=create.chromR(vcf_file,name = "CHROM",seq = NULL, verbose = TRUE)
a=w@var.info
