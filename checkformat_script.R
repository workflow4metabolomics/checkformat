## Etienne Thevenot
## CEA, MetaboHUB Paris
## etienne.thevenot@cea.fr


## Reads the dataMatrix, sampleMetadata, and variableMetadata .tsv files
## and checks the formats
readAndCheckF <- function(datFilC="dataMatrix.tsv",
                          samFilC="sampleMetadata.tsv",
                          varFilC="variableMetadata.tsv") {

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

        rowMakVc <- make.names(rowVc, unique = TRUE)

        rowDifVl <- rowVc != rowMakVc

        if(any(rowDifVl)) {
            rowDifDF <- data.frame(row = 1:length(rowVc),
                                   actual = rowVc,
                                   preferred = rowMakVc)
            rowDifDF <- rowDifDF[rowDifVl, , drop = FALSE]
            cat("\n\nWarning: The following row names of the ",
                tabNamC,
                " table are not in the standard R format, which may result in errors when loading the data in some of the W4M modules:\n", sep="")
            print(rowDifDF)
        }

        colMakVc <- make.names(colVc, unique = TRUE)

        colDifVl <- colVc != colMakVc

        if(any(colDifVl)) {
            colDifDF <- data.frame(col = 1:length(colVc),
                                   actual = colVc,
                                   preferred = colMakVc)
            colDifDF <- colDifDF[colDifVl, , drop = FALSE]
            cat("\n\nWarning: The following column names of the ",
                tabNamC,
                " table are not in the standard R format, which may result in errors when loading the data in some of the W4M modules:\n", sep="")
            print(colDifDF)
        }
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

    ## checking formats

    chkL <- TRUE

    if(!identical(rownames(datMN), rownames(samDF))) {
        ## checking sample names

        chkL <- FALSE

        datSamDifVc <- setdiff(rownames(datMN), rownames(samDF))

        if(length(datSamDifVc)) {
            cat("\nThe following samples were found in the dataMatrix column names but not in the sampleMetadata row names:\n", sep="")
            print(cbind.data.frame(col = as.numeric(sapply(datSamDifVc, function(samC) which(rownames(datMN) == samC))),
                                   name = datSamDifVc))
        }

        samDatDifVc <- setdiff(rownames(samDF), rownames(datMN))

        if(length(samDatDifVc)) {
            cat("\n\nThe following samples were found in the sampleMetadata row names but not in the dataMatrix column names:\n", sep="")
            print(cbind.data.frame(row = as.numeric(sapply(samDatDifVc, function(samC) which(rownames(samDF) == samC))),
                                   name = samDatDifVc))
        }

        if(nrow(datMN) != nrow(samDF)) {
            cat("\n\nThe dataMatrix has ", nrow(datMN), " columns (ie samples) whereas the sampleMetadata has ", nrow(samDF), " rows\n", sep="")
        } else if(identical(gsub("^X", "", rownames(datMN)), rownames(samDF))) {
            cat("\n\nThe dataMatrix column names start with an 'X' but not the sampleMetadata row names\n", sep="")
        } else if(identical(gsub("^X", "", rownames(samDF)), rownames(datMN))) {
            cat("\n\nThe sampleMetadata row names start with an 'X' but not the dataMatrix column names\n", sep="")
        } else if(identical(sort(rownames(datMN)), sort(rownames(samDF)))) {
            cat("\n\nThe dataMatrix column names and the sampleMetadata row names are not in the same order:\n", sep="")
            print(cbind.data.frame(indice = 1:nrow(datMN),
                                   dataMatrix_columnnames=rownames(datMN),
                                   sampleMetadata_rownames=rownames(samDF))[rownames(datMN) != rownames(samDF), , drop = FALSE])
        } else {
            cat("\n\nThe dataMatrix column names and the sampleMetadata row names are not identical:\n", sep="")
            print(cbind.data.frame(indice = 1:nrow(datMN),
                                   dataMatrix_columnnames=rownames(datMN),
                                   sampleMetadata_rownames=rownames(samDF))[rownames(datMN) != rownames(samDF), , drop = FALSE])
        }

    }

    if(!identical(colnames(datMN), rownames(varDF))) {
        ## checking variable names

        chkL <- FALSE

        datVarDifVc <- setdiff(colnames(datMN), rownames(varDF))

        if(length(datVarDifVc)) {
            cat("\nThe following variables were found in the dataMatrix row names but not in the variableMetadata row names:\n", sep="")
            print(cbind.data.frame(row = as.numeric(sapply(datVarDifVc, function(varC) which(colnames(datMN) == varC))),
                        name = datVarDifVc))

        }

        varDatDifVc <- setdiff(rownames(varDF), colnames(datMN))

        if(length(varDatDifVc)) {
            cat("\n\nThe following variables were found in the variableMetadata row names but not in the dataMatrix row names:\n", sep="")
            print(cbind.data.frame(row = as.numeric(sapply(varDatDifVc, function(varC) which(rownames(varDF) == varC))),
                        name = varDatDifVc))
        }

        if(ncol(datMN) != nrow(varDF)) {
            cat("\n\nThe dataMatrix has ", nrow(datMN), " rows (ie variables) whereas the variableMetadata has ", nrow(varDF), " rows\n", sep="")
        } else if(identical(sort(colnames(datMN)), sort(rownames(varDF)))) {
            cat("\n\nThe dataMatrix row names and the variableMetadata row names are not in the same order:\n", sep="")
            print(cbind.data.frame(row = 1:ncol(datMN),
                                   dataMatrix_rownames=colnames(datMN),
                                   variableMetadata_rownames=rownames(varDF))[colnames(datMN) != rownames(varDF), , drop = FALSE])
        } else {
            cat("\n\nThe dataMatrix row names and the variableMetadata row names are not identical:\n", sep="")
            print(cbind.data.frame(row = 1:ncol(datMN),
                                   dataMatrix_rownames=colnames(datMN),
                                   variableMetadata_rownames=rownames(varDF))[colnames(datMN) != rownames(varDF), , drop = FALSE])
        }
    }

    options(stringsAsFactors=optStrAsFacL)

    resLs <- list(chkL=chkL)

    return(resLs)

} ## end of checkAndReadF
