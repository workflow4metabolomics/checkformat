#!/usr/bin/Rscript --vanilla --slave --no-site-file


library(batch) ## necessary for parseCommandArgs function
args = parseCommandArgs(evaluate=FALSE)
## interpretation of arguments given in command line as an R list of objects

source_local <- function(fname){
    argv <- commandArgs(trailingOnly = FALSE)
    base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
    source(paste(base_dir, fname, sep="/"))
}

## Import the different functions
source_local("checkFormat_script.R")




runExampleL <- FALSE

if(runExampleL) { ## example of arguments

    ## prefix file in
    pfxFilInpC <- "data/input/sacuri_"                       ## 'sacuri'
    ## pfxFilInpC <- gsub("sacuri", "suvimax", pfxFilInpC)   ## 'suvimax'
    ## pfxFilInpC <- gsub("sacuri", "bisphenol", pfxFilInpC) ## 'bisphenol'

    argLs <- list(dataMatrix_in = paste0(pfxFilInpC, "dataMatrix.tsv"),
                  sampleMetadata_in = paste0(pfxFilInpC, "sampleMetadata.tsv"),
                  variableMetadata_in = paste0(pfxFilInpC, "variableMetadata.tsv"))

    ## prefix file out
    pfxFilOutC <- gsub("input", "output",
                       gsub("dataMatrix.tsv", "", argLs[["dataMatrix_in"]]))
    ## "output/sacuri_"

    argLs <- c(argLs,
               list(dataMatrix_out = paste0(pfxFilOutC, "dataMatrix.tsv"),
                    sampleMetadata_out = paste0(pfxFilOutC, "sampleMetadata.tsv"),
                    variableMetadata_out = paste0(pfxFilOutC, "variableMetadata.tsv"),
                    information = paste0(pfxFilOutC, "information.txt")))

    stopifnot(file.exists("data/output"))

} else {

    argLs <- parseCommandArgs(evaluate=FALSE)

}

sink(argLs[["information"]])
on.exit(sink())

## Script
##-------

resLs <- readAndCheckF(argLs[["dataMatrix_in"]],
                       argLs[["sampleMetadata_in"]],
                       argLs[["variableMetadata_in"]])

if(resLs[["chkL"]]) {

    datDF <- cbind.data.frame(dataMatrix = colnames(resLs[["datMN"]]),
                              as.data.frame(t(resLs[["datMN"]])))
    write.table(datDF,
                file = argLs[["dataMatrix_out"]],
                quote = FALSE,
                row.names = FALSE,
                sep = "\t")

    samDF <- cbind.data.frame(sampleMetadata = rownames(resLs[["samDF"]]),
                              resLs[["samDF"]])
    write.table(samDF,
                file = argLs[["sampleMetadata_out"]],
                quote = FALSE,
                row.names = FALSE,
                sep = "\t")

    varDF <- cbind.data.frame(variableMetadata = rownames(resLs[["varDF"]]),
                              resLs[["varDF"]])
    write.table(varDF,
                file = argLs[["variableMetadata_out"]],
                quote = FALSE,
                row.names = FALSE,
                sep = "\t")

    cat("Table formats are OK; enjoy your analyses!", sep="")
    sink()
} else {
    sink()
    stop("Please check the generated 'information' file")
}

rm(list = ls())
