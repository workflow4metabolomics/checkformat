## Etienne Thevenot
## CEA, MetaboHUB Paris
## etienne.thevenot@cea.fr



## Reads the dataMatrix, sampleMetadata, and variableMetadata .tsv files
## and checks the formats
readAndCheckF <- function(datFilC="dataMatrix.tsv",
                          samFilC="sampleMetadata.tsv",
                          varFilC="variableMetadata.tsv",
                          makNamL) {
    

    ## options

    optStrAsFacL <- options()[["stringsAsFactors"]]
    options(stringsAsFactors = FALSE)
    

    ## checking that the tables have no duplicated row or column names

    for(tabC in c("dat", "sam", "var")) {

        tabNamC <- switch(tabC, dat="dataMatrix", sam="sampleMetadata", var="variableMetadata")

        rowVc <- read.table(eval(parse(text=paste0(tabC, "FilC"))),
                            check.names = FALSE,
                            header = TRUE,
                            sep = "\t")[, 1]

        colVc <- unlist(read.table(eval(parse(text=paste0(tabC, "FilC"))),
                                   check.names = FALSE,
                                   nrow=1,
                                   sep = "\t"))[-1]

        if(any(duplicated(rowVc)))
            stop("The following row name(s) is/are duplicated in the ",
                 tabNamC,
                 " table: '",
                 paste(rowVc[duplicated(rowVc)], collapse="', '"), "'",
                 call.=FALSE)

        if(any(duplicated(colVc)))
            stop("The following column name(s) is/are duplicated in the ",
                 tabNamC,
                 " table: '",
                 paste(colVc[duplicated(colVc)], collapse="', '"), "'",
                 call.=FALSE)

    }
    

    ## reading tables

    datMN <- t(as.matrix(read.table(datFilC,
                                    check.names = FALSE,
                                    header = TRUE,
                                    row.names = 1,
                                    sep = "\t")))

    samDF <- read.table(samFilC,
                        check.names = FALSE,
                        header = TRUE,
                        row.names = 1,
                        sep = "\t")

    varDF <- read.table(varFilC,
                        check.names = FALSE,
                        header = TRUE,
                        row.names = 1,
                        sep = "\t")
    

    ## checking that dataMatrix is numeric and that the sample and variable numbers are coherent

    if(mode(datMN) != "numeric") {
        stop("The dataMatrix is not of the 'numeric' type",
             call. = FALSE)
    }
    
    if(nrow(datMN) != nrow(samDF)) {
        if(nrow(datMN) > nrow(samDF)) {
            print(setdiff(rownames(datMN), rownames(samDF)))
            stop("The sample names above from dataMatrix were not found in sampleMetadata")
        } else {
            print(setdiff(rownames(samDF), rownames(datMN)))
            stop("The sample names above from sampleMetadata were not found in dataMatrix")
        }
    }

    if(ncol(datMN) != nrow(varDF)) {
        if(ncol(datMN) > nrow(varDF)) {
            print(setdiff(colnames(datMN), rownames(varDF)))
            stop("The variable names above from dataMatrix were not found in variableMetadata")
        } else {
            print(setdiff(rownames(varDF), colnames(datMN)))
            stop("The variable names above from variableMetadata were not found in dataMatrix")
        }
    }
    

    ## making sample and variable names (optional)

    newL <- FALSE

    if(makNamL) {

        cat("\n\nMessage: Converting sample and variable names to the standard R format\n")

        rownames(datMN) <- make.names(rownames(datMN), unique = TRUE)
        colnames(datMN) <- make.names(colnames(datMN), unique = TRUE)
        rownames(samDF) <- make.names(rownames(samDF), unique = TRUE)
        rownames(varDF) <- make.names(rownames(varDF), unique = TRUE)

        newL <- TRUE

    }
    
 
    ## checking sample and variable names

    chkL <- TRUE

    if(!identical(rownames(datMN), rownames(samDF))) {

        if(identical(sort(rownames(datMN)), sort(rownames(samDF)))) {

            cat("\n\nMessage: Re-ordering dataMatrix sample names to match sampleMetadata\n")
            datMN <- datMN[rownames(samDF), , drop = FALSE]
            
            stopifnot(identical(sort(rownames(datMN)), sort(rownames(samDF))))

            newL <- TRUE
            
        }  else {
            
            cat("\n\nStop: The sample names of dataMatrix and sampleMetadata do not match:\n")
            print(cbind.data.frame(indice = 1:nrow(datMN),
                                   dataMatrix=rownames(datMN),
                                   sampleMetadata=rownames(samDF))[rownames(datMN) != rownames(samDF), , drop = FALSE])
            chkL <- FALSE
            
        }

    }

    if(!identical(colnames(datMN), rownames(varDF))) {
        
        if(identical(sort(colnames(datMN)), sort(rownames(varDF)))) {
            
            cat("\n\nMessage: Re-ordering dataMatrix variable names to match variableMetadata\n")
            datMN <- datMN[, rownames(varDF), drop = FALSE]

            stopifnot(identical(sort(colnames(datMN)), sort(rownames(varDF))))

            newL <- TRUE
            
        }  else {
            
            cat("\n\nStop: The variable names of dataMatrix and variableMetadata do not match:\n")
            print(cbind.data.frame(indice = 1:ncol(datMN),
                                   dataMatrix=colnames(datMN),
                                   variableMetadata=rownames(varDF))[colnames(datMN) != rownames(varDF), , drop = FALSE])
            chkL <- FALSE
            
        }

    }
        

    options(stringsAsFactors=optStrAsFacL)

    resLs <- list(chkL=chkL,
                  newL = newL,
                  datMN = datMN,
                  samDF = samDF,
                  varDF = varDF)

    return(resLs)

} ## end of checkAndReadF




    ## if(!identical(rownames(datMN), rownames(samDF))) {
    ##     ## checking sample names

    ##     chkL <- FALSE

    ##     datSamDifVc <- setdiff(rownames(datMN), rownames(samDF))

    ##     if(length(datSamDifVc)) {
    ##         cat("\nThe following samples were found in the dataMatrix column names but not in the sampleMetadata row names:\n", sep="")
    ##         print(cbind.data.frame(col = as.numeric(sapply(datSamDifVc, function(samC) which(rownames(datMN) == samC))),
    ##                                name = datSamDifVc))
    ##     }

    ##     samDatDifVc <- setdiff(rownames(samDF), rownames(datMN))

    ##     if(length(samDatDifVc)) {
    ##         cat("\n\nThe following samples were found in the sampleMetadata row names but not in the dataMatrix column names:\n", sep="")
    ##         print(cbind.data.frame(row = as.numeric(sapply(samDatDifVc, function(samC) which(rownames(samDF) == samC))),
    ##                                name = samDatDifVc))
    ##     }

    ##     if(nrow(datMN) != nrow(samDF)) {
    ##         cat("\n\nThe dataMatrix has ", nrow(datMN), " columns (ie samples) whereas the sampleMetadata has ", nrow(samDF), " rows\n", sep="")
    ##     } else if(identical(gsub("^X", "", rownames(datMN)), rownames(samDF))) {
    ##         cat("\n\nThe dataMatrix column names start with an 'X' but not the sampleMetadata row names\n", sep="")
    ##     } else if(identical(gsub("^X", "", rownames(samDF)), rownames(datMN))) {
    ##         cat("\n\nThe sampleMetadata row names start with an 'X' but not the dataMatrix column names\n", sep="")
    ##     } else if(identical(sort(rownames(datMN)), sort(rownames(samDF)))) {
    ##         cat("\n\nThe dataMatrix column names and the sampleMetadata row names are not in the same order:\n", sep="")
    ##         print(cbind.data.frame(indice = 1:nrow(datMN),
    ##                                dataMatrix_columnnames=rownames(datMN),
    ##                                sampleMetadata_rownames=rownames(samDF))[rownames(datMN) != rownames(samDF), , drop = FALSE])
    ##     } else {
    ##         cat("\n\nThe dataMatrix column names and the sampleMetadata row names are not identical:\n", sep="")
    ##         print(cbind.data.frame(indice = 1:nrow(datMN),
    ##                                dataMatrix_columnnames=rownames(datMN),
    ##                                sampleMetadata_rownames=rownames(samDF))[rownames(datMN) != rownames(samDF), , drop = FALSE])
    ##     }

    ## }
    ##     datRowVc <- rownames(datMN)
    ##     datRowMakVc <- make.names(datRowVc, unique = TRUE)
    ##     if(datRowMakVc != datRowVc) {
    ##         rownames(datMN) <- datRowMakVc
    ##         cat("\n\nMessage: The sample names of the dataMatrix have been converted to the standard R format\n")
    ##     }

    ##     datColVc <- colnames(datMN)
    ##     datColMakVc <- make.names(datColVc, unique = TRUE)
    ##     if(datColMakVc != datColVc) {
    ##         colnames(datMN) <- datColMakVc
    ##         cat("\n\nMessage: The variable names of the dataMatrix have been converted to the standard R format\n")
    ##     }

    ##     samRowVc <- rownames(datMN)
    ##     samRowMakVc <- make.names(samRowVc, unique = TRUE)
    ##     if(samRowMakVc != samRowVc) {
    ##         rownames(datMN) <- samRowMakVc
    ##         cat("\n\nMessage: The sample names of the sampleMetadata have been converted to the standard R format\n")
    ##     }

    ##     datRowVc <- rownames(datMN)
    ##     datRowMakVc <- make.names(datRowVc, unique = TRUE)
    ##     if(datRowMakVc != datRowVc) {
    ##         rownames(datMN) <- datRowMakVc
    ##         cat("\n\nMessage: The sample names of the dataMatrix have been converted to the standard R format\n")
    ##     }

    ## }

    ## checking names (optional)

    


    ## datRowMakVc <- make.names(datRowVc, unique = TRUE)
    ## if(datRowMakVc != datRowVc) {
    ##     if(makNamL) {
    ##         rownames(datMN) <- datRowMakVc
    ##         cat("\n\nMessage: The sample names of the dataMatrix have been converted to the standard R format; select the make names argument to convert them\n")
    ##     } else {
    ##         cat("\n\nWarning: Some of the sample names of the dataMatrix are not in the standard R format; select the make names argument to convert them\n")
    ##     }

    ## if(makNamL) {

    ##     rownames(datMN) <- make.names(rownames(datMN), unique = TRUE)
    ##     colnames(datMN) <- make.names(colnames(datMN), unique = TRUE)
    ##     rownames(samDF) <- make.names(rownames(samDF), unique = TRUE)
    ##     rownames(varDF) <- make.names(rownames(varDF), unique = TRUE)
 
    ##     }
        ## checking sample names

    ##     if(nrow(datMN) == nrow(samDF)) {

            
            
    ##     }

    ##     chkL <- FALSE

    ##     datSamDifVc <- setdiff(rownames(datMN), rownames(samDF))

    ##     if(length(datSamDifVc)) {
    ##         cat("\nThe following samples were found in the dataMatrix column names but not in the sampleMetadata row names:\n", sep="")
    ##         print(cbind.data.frame(col = as.numeric(sapply(datSamDifVc, function(samC) which(rownames(datMN) == samC))),
    ##                                name = datSamDifVc))
    ##     }

    ##     samDatDifVc <- setdiff(rownames(samDF), rownames(datMN))

    ##     if(length(samDatDifVc)) {
    ##         cat("\n\nThe following samples were found in the sampleMetadata row names but not in the dataMatrix column names:\n", sep="")
    ##         print(cbind.data.frame(row = as.numeric(sapply(samDatDifVc, function(samC) which(rownames(samDF) == samC))),
    ##                                name = samDatDifVc))
    ##     }

    ##     if(nrow(datMN) != nrow(samDF)) {
    ##         cat("\n\nThe dataMatrix has ", nrow(datMN), " columns (ie samples) whereas the sampleMetadata has ", nrow(samDF), " rows\n", sep="")
    ##     } else if(identical(gsub("^X", "", rownames(datMN)), rownames(samDF))) {
    ##         cat("\n\nThe dataMatrix column names start with an 'X' but not the sampleMetadata row names\n", sep="")
    ##     } else if(identical(gsub("^X", "", rownames(samDF)), rownames(datMN))) {
    ##         cat("\n\nThe sampleMetadata row names start with an 'X' but not the dataMatrix column names\n", sep="")
    ##     } else if(identical(sort(rownames(datMN)), sort(rownames(samDF)))) {
    ##         cat("\n\nThe dataMatrix column names and the sampleMetadata row names are not in the same order:\n", sep="")
    ##         print(cbind.data.frame(indice = 1:nrow(datMN),
    ##                                dataMatrix_columnnames=rownames(datMN),
    ##                                sampleMetadata_rownames=rownames(samDF))[rownames(datMN) != rownames(samDF), , drop = FALSE])
    ##     } else {
    ##         cat("\n\nThe dataMatrix column names and the sampleMetadata row names are not identical:\n", sep="")
    ##         print(cbind.data.frame(indice = 1:nrow(datMN),
    ##                                dataMatrix_columnnames=rownames(datMN),
    ##                                sampleMetadata_rownames=rownames(samDF))[rownames(datMN) != rownames(samDF), , drop = FALSE])
    ##     }

    ## }


    ## if(!identical(colnames(datMN), rownames(varDF))) {
    ##     ## checking variable names

    ##     chkL <- FALSE

    ##     datVarDifVc <- setdiff(colnames(datMN), rownames(varDF))

    ##     if(length(datVarDifVc)) {
    ##         cat("\nThe following variables were found in the dataMatrix row names but not in the variableMetadata row names:\n", sep="")
    ##         print(cbind.data.frame(row = as.numeric(sapply(datVarDifVc, function(varC) which(colnames(datMN) == varC))),
    ##                     name = datVarDifVc))

    ##     }

    ##     varDatDifVc <- setdiff(rownames(varDF), colnames(datMN))

    ##     if(length(varDatDifVc)) {
    ##         cat("\n\nThe following variables were found in the variableMetadata row names but not in the dataMatrix row names:\n", sep="")
    ##         print(cbind.data.frame(row = as.numeric(sapply(varDatDifVc, function(varC) which(rownames(varDF) == varC))),
    ##                     name = varDatDifVc))
    ##     }

    ##     if(ncol(datMN) != nrow(varDF)) {
    ##         cat("\n\nThe dataMatrix has ", nrow(datMN), " rows (ie variables) whereas the variableMetadata has ", nrow(varDF), " rows\n", sep="")
    ##     } else if(identical(sort(colnames(datMN)), sort(rownames(varDF)))) {
    ##         cat("\n\nThe dataMatrix row names and the variableMetadata row names are not in the same order:\n", sep="")
    ##         print(cbind.data.frame(row = 1:ncol(datMN),
    ##                                dataMatrix_rownames=colnames(datMN),
    ##                                variableMetadata_rownames=rownames(varDF))[colnames(datMN) != rownames(varDF), , drop = FALSE])
    ##     } else {
    ##         cat("\n\nThe dataMatrix row names and the variableMetadata row names are not identical:\n", sep="")
    ##         print(cbind.data.frame(row = 1:ncol(datMN),
    ##                                dataMatrix_rownames=colnames(datMN),
    ##                                variableMetadata_rownames=rownames(varDF))[colnames(datMN) != rownames(varDF), , drop = FALSE])
    ##     }
    ## }
## checkF <- function(datInpMN,
##                    samInpDF,
##                    varInpDF) {

##     mode(datInpMN) == "numeric" &&
##         identical(rownames(datInpMN), rownames(samInpDF)) &&
##         identical(colnames(datInpMN), rownames(varInpDF))
    

## }
