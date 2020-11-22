## Libraries and Data
library(tidyverse)
library(tidymodels)

peng_data <-  read.csv("Palomer_Pengs_ML_Proj/Data/peng_data.csv")

## Quick Look at data
skimr::skim(peng_data) #344 different data points. Cross validation for sure.

peng_ml <- peng_data %>% 
  select(species, bill_length_mm, bill_depth_mm, body_mass_g, flipper_length_mm) #trying to predict speices based on physical characteristics
write.csv(peng_ml, "Palomer_Pengs_ML_Proj/Data/peng_ml.csv")


peng_ml_clean <- peng_ml %>% 
  na.omit() # removing 2 entries missing all data - we could impute, however these 2 are not great candidates as they have no data whatsoever. 


## Creating splits

set.seed(123)
peng_split <- initial_split(peng_ml_clean, strata = species)

peng_train <- training(peng_split)
peng_test <-  testing(peng_split)

#Folds
set.seed(222)
peng_fold <- vfold_cv(peng_train, strata = species)
peng_fold


#Models

#SVM
#Logistic
#RF
#KNN
