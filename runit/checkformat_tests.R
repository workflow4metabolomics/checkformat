test_input_default <- function() {

    testDirC <- "input"
    argLs <- list(makeNameL = FALSE)

    argLs <- c(defaultArgF(testDirC), argLs)
    outLs <- wrapperCallF(argLs)

    checkEquals(outLs[['infVc']][4], 'The input tables have a correct format and can be used for your analyses')

}
