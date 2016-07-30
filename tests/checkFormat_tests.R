#!/usr/bin/env Rscript

## Package
##--------

library(RUnit)

## Constants
##----------

tesOutDirC <- "output"

## Functions
##-----------

## Reading tables (matrix or data frame)
reaTabF <- function(filC, typC = c("matrix", "dataframe")[1]) {

    	file.exists(filC) || stop(paste0("No output file \"", filC ,"\"."))

        switch(typC,
               matrix = return(t(as.matrix(read.table(file = filC,
                   header = TRUE,
                   row.names = 1,
                   sep = "\t",
                   stringsAsFactors = FALSE)))),
               dataframe = return(read.table(file = filC,
                   header = TRUE,
                   row.names = 1,
                   sep = "\t",
                   stringsAsFactors = FALSE)))

}

## Call wrapper
wrpCalF <- function(parLs) {

	## Set program path
    	wrpPatC <- file.path("..", "checkFormat_wrapper.R")

	## Set arguments
	argLs <- NULL
	for (parC in names(parLs))
		argLs <- c(argLs, parC, parLs[[parC]])

	## Call
	wrpCalC <- paste(c(wrpPatC, argLs), collapse = " ")

        if(.Platform$OS.type == "windows")
            wrpCalC <- paste("Rscript", wrpCalC)

	wrpCodN <- system(wrpCalC)

	if (wrpCodN != 0)
		stop("Error when running checkFormat_wrapper.R.")

	## Get output
	outLs <- list()
	if ("dataMatrix_out" %in% names(parLs))
            outLs[["datMN"]] <- reaTabF(parLs[["dataMatrix_out"]], "matrix")
	if ("sampleMetadata_out" %in% names(parLs))
            outLs[["samDF"]] <- reaTabF(parLs[["sampleMetadata_out"]], "dataframe")
	if ("variableMetadata_out" %in% names(parLs))
            outLs[["varDF"]] <- reaTabF(parLs[["variableMetadata_out"]], "dataframe")
        if("information" %in% names(parLs))
            outLs[["infVc"]] <- readLines(parLs[["information"]])

	return(outLs)
}

## Setting default parameters
argDefF <- function(tesC) {

    tesInpDirC <- unlist(strsplit(tesC, "_"))[1]

    argDefLs <- list()
    if(file.exists(file.path(tesInpDirC, "dataMatrix.tsv")))
        argDefLs[["dataMatrix_in"]] <- file.path(tesInpDirC, "dataMatrix.tsv")
    if(file.exists(file.path(tesInpDirC, "sampleMetadata.tsv")))
        argDefLs[["sampleMetadata_in"]] <- file.path(tesInpDirC, "sampleMetadata.tsv")
    if(file.exists(file.path(tesInpDirC, "variableMetadata.tsv")))
        argDefLs[["variableMetadata_in"]] <- file.path(tesInpDirC, "variableMetadata.tsv")
    if(file.exists(file.path(tesOutDirC, "dataMatrix.tsv")))
        argDefLs[["dataMatrix_out"]] <- file.path(tesOutDirC, "dataMatrix.tsv")
    if(file.exists(file.path(tesOutDirC, "sampleMetadata.tsv")))
        argDefLs[["sampleMetadata_out"]] <- file.path(tesOutDirC, "sampleMetadata.tsv")
    if(file.exists(file.path(tesOutDirC, "variableMetadata.tsv")))
        argDefLs[["variableMetadata_out"]] <- file.path(tesOutDirC, "variableMetadata.tsv")

    ## argDefLs[["figure"]] <- file.path(tesOutDirC, "figure.pdf")
    argDefLs[["information"]] <- file.path(tesOutDirC, "information.txt")

    argDefLs

}

## Main
##-----

## Create output folder

file.exists(tesOutDirC) || dir.create(tesOutDirC)

test_input_default <- function() {

    tesC <- "input_default"
    chkC <- "checkEquals(outLs[['infVc']][4], 'Table formats are OK; enjoy your analyses!')"

    argLs <- argDefF(tesC = tesC)
    outLs <- wrpCalF(argLs)
    stopifnot(eval(parse(text = chkC)))

}



