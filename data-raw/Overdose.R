# Overdose data
# from: https://library.virginia.edu/data/articles/getting-started-with-multivariate-multiple-regression

# data from  Applied Multivariate Statistical Analysis (6th ed.) by Richard Johnson and Dean Wichern. 
# This data come from exercise 7.25 and involve 17 overdoses of the drug amitriptyline (Rudorfer, 1982). 
# There are two responses : TOT and AMI. 
# 
# TOT is total TCAD plasma level and 
# AMI is the amount of amitriptyline present in the TCAD plasma level. 
# 
# The predictors are as follows:
# 
#     GEN, gender (male = 0, female = 1)
#     AMT, amount of drug taken at time of overdose -> amount
#     PR, PR wave measurement, https://en.wikipedia.org/wiki/PR_interval, measure of ECG PR interval
#     DIAP, diastolic blood pressure -> BP
#     QRS, QRS wave measurement, https://en.wikipedia.org/wiki/QRS_complex, measures of graphical deflections seen on a typical electrocardiogram 
    

ami_data <- read.table("http://static.lib.virginia.edu/statlab/materials/data/ami_data.DAT")
names(ami_data) <- c("TCAD","AMI","Gender","amount","PR","BP","QRS")

library(dplyr)
Overdose <- ami_data |>
  relocate(BP, .before = PR) |>
  rename(ECG_PR = PR, ECG_QRS = QRS) |>
  mutate(Gender = factor(Gender, labels = "Male", "Female")) |> print()





