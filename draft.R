rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 2){
  mortality = as.numeric(args[1])
  file = args[2]
} else {
  cat('usage: Rscript draft.R <mortality> <datadir>\n', file=stderr())
  stop()
}

library("FITSio")
library(tidyverse)
library(dplyr)

#Retrieve the lifespan of dead patients from diagnosis of ALS to death as well as their ID
mortality = read.csv("113.csv")
ID_date_data = data.frame(dieddt = mortality$dieddt, Participant_ID = mortality$Participant_ID)

#Create csv we're looking at
data = read.csv(paste0(file,".csv"))

#Add mortality to our data variable based off of Participant_ID and delete rows with no data in mortality column
newdata = left_join(data, ID_date_data, by="Participant_ID")
newdata = drop_na(newdata, "dieddt")


#Create 3 vectors to store our data within for loop to create data frame later
x = c()
p = c()
c = c()

df = select_if(newdata, is.numeric)
is_unique = lengths(lapply(df, unique)) > 1

#Look through each column in our csv file
for(i in 1:ncol(df)){
  #Create variable to have the names of each column in csv
  names = names(df)
  
  #Create model with death ~ variable
  if(is_unique[i]){
    fit = lm(df$dieddt ~ as.factor(df[[i]]))
    aov = anova(fit)
    
    #Add the name, p-value, and name of csv file into vectors
    x = c(x, names[i])
    p = c(p, aov$`Pr(>F)`[1])
    c = c(c, file)
  }
}

#Create data frame from our 3 vectors made earlier
results = data.frame(x_value = x, pval = p, csv = c)
write_csv(results, paste0("results", file, ".csv"))

