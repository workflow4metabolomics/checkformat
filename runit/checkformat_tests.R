test_input_default <- function() {

    testDirC <- "input"
    argLs <- list(makeNameL = FALSE)

    argLs <- c(defaultArgF(testDirC), argLs)
    outLs <- wrapperCallF(argLs)

    checkEquals(outLs[['infVc']][4], 'The input tables have a correct format and can be used for your analyses.')

}

test_datSamInv <- function() {

    ## first two samples inverted in dataMatrix
    
    testDirC <- "datSamInv"
    argLs <- list(makeNameL = FALSE)

    argLs <- c(defaultArgF(testDirC), argLs)
    outLs <- wrapperCallF(argLs)

    checkEquals(outLs[['infVc']][7], 'Warning: The sample and/or variable names or orders from the input tables have been modified')

}

test_datSamFls <- function() {

    ## first sample name in dataMatrix is 17, and in sampleMetadata is X17

    ## also used in test-data
    
    testDirC <- "datSamFls"
    argLs <- list(makeNameL = TRUE)

    argLs <- c(defaultArgF(testDirC), argLs)
    outLs <- wrapperCallF(argLs)

    checkEquals(outLs[['infVc']][5], 'Message: Converting sample and variable names to the standard R format')
    
    checkEquals(outLs[['infVc']][7], 'Warning: The sample and/or variable names or orders from the input tables have been modified')

    checkEquals(rownames(outLs[['datMN']])[1], 'X17')

}

test_datSamFlsInv <- function() {

    ## first sample name in dataMatrix is X17, and in sampleMetadata is 17
    
    testDirC <- "datSamFlsInv"
    argLs <- list(makeNameL = TRUE)

    argLs <- c(defaultArgF(testDirC), argLs)
    outLs <- wrapperCallF(argLs)

    checkEquals(outLs[['infVc']][5], 'Message: Converting sample and variable names to the standard R format')
    
    checkEquals(outLs[['infVc']][7], 'Warning: The sample and/or variable names or orders from the input tables have been modified')

    checkEquals(rownames(outLs[['samDF']])[1], 'X17')

}

test_datVarInv <- function() {

    ## first two variables inverted in variableMetadata
    
    testDirC <- "datVarInv"
    argLs <- list(makeNameL = FALSE)

    argLs <- c(defaultArgF(testDirC), argLs)
    outLs <- wrapperCallF(argLs)

    checkEquals(outLs[['infVc']][7], 'Warning: The sample and/or variable names or orders from the input tables have been modified')

}

test_datVarFls <- function() {

    ## second variable name in dataMatrix is 3072, and in variableMetadata is X3072
    
    testDirC <- "datVarFls"
    argLs <- list(makeNameL = TRUE)

    argLs <- c(defaultArgF(testDirC), argLs)
    outLs <- wrapperCallF(argLs)

    checkEquals(outLs[['infVc']][5], 'Message: Converting sample and variable names to the standard R format')
    
    checkEquals(outLs[['infVc']][7], 'Warning: The sample and/or variable names or orders from the input tables have been modified')

    checkEquals(colnames(outLs[['datMN']])[2], 'X3072')

}
