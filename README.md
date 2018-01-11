Checking/formatting the sample and variable names of the dataMatrix, sampleMetadata, and variableMetadata files  
===============================================================================================================  

A Galaxy module from the [Workflow4metabolomics](http://workflow4metabolomics.org) infrastructure  

Status: [![Build Status](https://travis-ci.org/workflow4metabolomics/checkformat.svg?branch=master)](https://travis-ci.org/workflow4metabolomics/checkformat).

### Description

**Version:** 3.0.0  
**Date:** 2018-01-10  
**Author:** Etienne A. Thevenot (CEA, LIST, MetaboHUB, W4M Core Development Team)   
**Email:** [etienne.thevenot(at)cea.fr](mailto:etienne.thevenot@cea.fr)  
**Citation:** Thevenot E.A., Roux A., Xu Y., Ezan E. and Junot C. (2015). Analysis of the human adult urinary metabolome variations with age, body mass index and gender by implementing a comprehensive workflow for univariate and OPLS statistical analyses. *Journal of Proteome Research*, **14**:3322-3335. [doi:10.1021/acs.jproteome.5b00354](http://dx.doi.org/10.1021/acs.jproteome.5b00354)  
**Licence:** CeCILL  
**Reference histories:**  
[W4M00001a_sacurine-subset-statistics](http://galaxy.workflow4metabolomics.org/history/list_published), [W4M00001b_sacurine_complete](http://galaxy.workflow4metabolomics.org/history/list_published),
[W4M00002_sacurine_mtbls2](http://galaxy.workflow4metabolomics.org/history/list_published), [W4M00003_sacurine_diaplasma](http://galaxy.workflow4metabolomics.org/history/list_published)  
**Funding:** Agence Nationale de la Recherche ([MetaboHUB](http://www.metabohub.fr/index.php?lang=en&Itemid=473) national infrastructure for metabolomics and fluxomics, ANR-11-INBS-0010 grant)

### Installation

* Configuration file: `checkformat_config.xml`
* Image file: `static/images/checkformat_workflowPositionImage.png`   
* Wrapper file: `checkformat_wrapper.R`  
* R packages  
    + **batch** from CRAN
 
    ```r
    install.packages("batch", dep=TRUE)  
    ```

### Tests

The code in the wrapper can be tested by running the `runit/checkformat_tests.R` R file

You will need to install **RUnit** package in order to make it run:
```r
install.packages('RUnit', dependencies = TRUE)
```

### Working example

See the **W4M00001a_sacurine-subset-statistics**, **W4M00001b_sacurine-complete**, **W4M00002_mtbls2**, or **W4M00003_diaplasma** shared histories in the **Shared Data/Published Histories** menu (https://galaxy.workflow4metabolomics.org/history/list_published)

### News

##### CHANGES IN VERSION 3.0.0  

NEW FEATURES  

 * Automated re-ordering (if necessary) of sample and/or variable names from dataMatrix based on sampleMetadata and variableMetadata  

 * New argument to make sample and variable names syntactically valid  

 * Output of dataMatrix, sampleMetadata, and variableMetadata files, whether they have been modified or not  
  
##### CHANGES IN VERSION 2.0.4 

INTERNAL MODIFICATION  

 * Minor internal modifications  

##### CHANGES IN VERSION 2.0.2  

INTERNAL MODIFICATION  

 * Creating tests for R code  