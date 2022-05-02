#!/bin/bash

awk '(NR == 1) || (FNR > 1)' results{100..112}.csv > pfiles1.csv
awk '(NR == 1) || (FNR > 1)' results{114..121}.csv > pfiles2.csv
awk '(NR == 1) || (FNR > 1)' pfiles* > allps.csv

sort -k2 -n -t, allps.csv > allsorted.csv

sed -n 57,75p allsorted.csv > bestps.csv
