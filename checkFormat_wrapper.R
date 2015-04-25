#!/usr/bin/Rscript --vanilla --slave --no-site-file


library(batch) ## parseCommandArgs

source_local <- function(fname){
    argv <- commandArgs(trailingOnly = FALSE)
    base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
    source(paste(base_dir, fname, sep="/"))
}

source_local("checkFormat_script.R")



rssVsGalL <- FALSE

if(rssVsGalL) { ## for running with R outside the Galaxy environment during development of the script

    ## 'example' input dir
    exaDirInpC <- "example/input"

    argLs <- list(dataMatrix_in = file.path(exaDirInpC, "dataMatrix.tsv"),
                  sampleMetadata_in = file.path(exaDirInpC, "sampleMetadata.tsv"),
                  variableMetadata_in = file.path(exaDirInpC, "variableMetadata.tsv"))

    ## 'example' output dir
    exaDirOutC <- gsub("input", "output", exaDirInpC)

    argLs <- c(argLs,
               list(information = file.path(exaDirOutC, "information.txt")))

    stopifnot(file.exists(exaDirOutC))

} else
    argLs <- parseCommandArgs(evaluate=FALSE)


##------------------------------
## Initializing
##------------------------------

## options
##--------

strAsFacL <- options()$stringsAsFactors
options(stringsAsFactors = FALSE)

## constants
##----------

modNamC <- "Check Format" ## module name

## log file
##---------

sink(argLs[["information"]])

cat("\nStart of the '", modNamC, "' Galaxy module call: ",
    format(Sys.time(), "%a %d %b %Y %X"), "\n", sep="")


##------------------------------
## Computation
##------------------------------


resLs <- readAndCheckF(argLs[["dataMatrix_in"]],
                       argLs[["sampleMetadata_in"]],
                       argLs[["variableMetadata_in"]])
chkL <- resLs[["chkL"]]


##------------------------------
## Ending
##------------------------------


if(chkL) {

    cat("\nTable formats are OK; enjoy your analyses!\n", sep="")

    cat("\nEnd of the '", modNamC, "' Galaxy module call: ",
        format(Sys.time(), "%a %d %b %Y %X"), "\n", sep="")

    sink()

} else {

    sink()
    stop("Please check the generated 'information' file")

}

## closing
##--------

options(stringsAsFactors = strAsFacL)

rm(list = ls())
