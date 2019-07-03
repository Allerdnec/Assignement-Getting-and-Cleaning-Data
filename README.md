# README

This repository contains all the files created for the assignement "Getting and Cleaning data" on the coursera plateform.

===============================

A full description about the data used in this analysis can be found at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

===============================

In addition to this README file this repository contains 3 other files:

* A "CodeBook.md" file describing every step of the analysis and containing informations about the data.
* An R script "run\_analysis.R" which will do the analysis as stipulate in the coursera plateform. Every step of the analysis as well as its purpose and the coursera instructions are detailled in the "CodeBook.md" file
* A tidy dataset called "samsung\_testtrain.txt" which is the result of this analysis. To read it back into R I suggest using the package "data.table" and the function "fread()" like so: fread("samsung\_testtrain.txt")
