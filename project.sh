#!/bin/bash

#echo $'100\n101\n102\n103\n104\n105\n106\n107\n108\n109\n110\n111\n112\n114\n115\n116\n117\n118\n119\n120\n121' > projfiles.txt

tar -xzf R402.tar.gz
tar -xzf packages_FITSio_tidyverse.tar.gz

export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

Rscript draft.R $1 $2
