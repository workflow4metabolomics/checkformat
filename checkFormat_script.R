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
                 switch(tabC, dat="dataMatrix", sam="sampleMetadata", var="variableMetadata"),
                 " table: '",
                 paste(rowVc[duplicated(rowVc)], collapse="', '"), "'",
                 call.=FALSE)

        if(any(duplicated(colVc)))
            stop("The following column name(s) is/are duplicated in the ",
                 switch(tabC, dat="dataMatrix", sam="sampleMetadata", var="variableMetadata"),
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

    ## checking formats

    chkL <- TRUE

    if(!identical(rownames(datMN), rownames(samDF))) {
        ## checking sample names

        chkL <- FALSE

        datSamDifVc <- setdiff(rownames(datMN), rownames(samDF))

        if(length(datSamDifVc)) {
            cat("\nThe following samples were found in the dataMatrix column names but not in the sampleMetadata row names:\n", sep="")
            print(datSamDifVc)
        }

        samDatDifVc <- setdiff(rownames(samDF), rownames(datMN))

        if(length(samDatDifVc)) {
            cat("\n\nThe following samples were found in the sampleMetadata row names but not in the dataMatrix column names:\n", sep="")
            print(samDatDifVc)
        }

        if(nrow(datMN) != nrow(samDF)) {
            cat("\n\nThe dataMatrix has ", nrow(datMN), " columns (ie samples) whereas the sampleMetadata has ", nrow(samDF), " rows\n", sep="")
        } else if(identical(gsub("^X", "", rownames(datMN)), rownames(samDF))) {
            cat("\n\nThe dataMatrix column names start with an 'X' but not the sampleMetadata row names\n", sep="")
        } else if(identical(gsub("^X", "", rownames(samDF)), rownames(datMN))) {
            cat("\n\nThe sampleMetadata row names start with an 'X' but not the dataMatrix column names\n", sep="")
        } else if(identical(sort(rownames(datMN)), sort(rownames(samDF)))) {
            cat("\n\nThe dataMatrix column names and the sampleMetadata row names are not in the same order:\n", sep="")
            print(cbind(dataMatrix_columnnames=rownames(datMN),
                        sampleMetadata_rownames=rownames(samDF)))
        } else {
            cat("\n\nThe dataMatrix column names and the sampleMetadata row names are not identical:\n", sep="")
            print(cbind(dataMatrix_columnnames=rownames(datMN),
                        sampleMetadata_rownames=rownames(samDF)))
        }

    }

    if(!identical(colnames(datMN), rownames(varDF))) {
        ## checking variable names

        chkL <- FALSE

        datVarDifVc <- setdiff(colnames(datMN), rownames(varDF))

        if(length(datVarDifVc)) {
            cat("\nThe following variables were found in the dataMatrix row names but not in the variableMetadata row names:\n", sep="")
            print(datVarDifVc)
        }

        varDatDifVc <- setdiff(rownames(varDF), colnames(datMN))

        if(length(varDatDifVc)) {
            cat("\n\nThe following variables were found in the variableMetadata row names but not in the dataMatrix row names:\n", sep="")
            print(varDatDifVc)
        }

        if(ncol(datMN) != nrow(varDF)) {
            cat("\n\nThe dataMatrix has ", nrow(datMN), " rows (ie variables) whereas the variableMetadata has ", nrow(varDF), " rows\n", sep="")
        } else if(identical(sort(colnames(datMN)), sort(rownames(varDF)))) {
            cat("\n\nThe dataMatrix row names and the variableMetadata row names are not in the same order:\n", sep="")
            print(cbind(dataMatrix_rownames=colnames(datMN),
                        variableMetadata_rownames=rownames(varDF)))
        } else {
            cat("\n\nThe dataMatrix row names and the variableMetadata row names are not identical:\n", sep="")
            print(cbind(dataMatrix_rownames=colnames(datMN),
                        variableMetadata_rownames=rownames(varDF)))
        }
    }

    options(stringsAsFactors=optStrAsFacL)

    resLs <- list(chkL=chkL)
    if(chkL) {
        resLs[["datMN"]] <- datMN
        resLs[["samDF"]] <- samDF
        resLs[["varDF"]] <- varDF
    }

    return(resLs)

} ## end of checkAndReadF
