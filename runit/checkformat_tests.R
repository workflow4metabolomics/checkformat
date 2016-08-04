test_input_default <- function() {

    testDirC <- "input"
    argLs <- list()

    argLs <- c(defaultArgF(testDirC), argLs)
    outLs <- wrapperCallF(argLs)

    checkEquals(outLs[['infVc']][4], 'Table formats are OK; enjoy your analyses!')

}
