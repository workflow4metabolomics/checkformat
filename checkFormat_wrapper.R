#!/usr/bin/Rscript --vanilla --slave --no-site-file

library(batch) ## parseCommandArgs

source_local <- function(fname){
    argv <- commandArgs(trailingOnly = FALSE)
    base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
    source(paste(base_dir, fname, sep="/"))
}

source_local("checkFormat_script.R")

argVc <- unlist(parseCommandArgs(evaluate = FALSE))


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

sink(argVc["information"])

cat("\nStart of the '", modNamC, "' Galaxy module call: ",
    format(Sys.time(), "%a %d %b %Y %X"), "\n", sep="")


##------------------------------
## Computation
##------------------------------


resLs <- readAndCheckF(argVc["dataMatrix_in"],
                       argVc["sampleMetadata_in"],
                       argVc["variableMetadata_in"])
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
