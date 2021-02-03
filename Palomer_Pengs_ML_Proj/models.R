## Libraries and Data
library(tidyverse)
library(tidymodels)

peng_data <-  read.csv("Palomer_Pengs_ML_Proj/Data/peng_data.csv")

## Quick Look at data
skimr::skim(peng_data) #344 different data points. Cross validation for sure.

peng_ml <- peng_data %>% 
  select(species, bill_length_mm, bill_depth_mm, body_mass_g, flipper_length_mm) %>% 
  mutate(species = as.factor(species))#trying to predict species based on physical characteristics
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
peng_fold <- bootstraps(peng_train, strata = species)
peng_fold


## Models ##



#SVM
svm_spec <- svm_rbf() %>% 
  set_mode("classification") %>% 
  set_engine("kernlab")
svm_spec
  
svm_rec <- recipe(species ~., data = peng_train) %>% 
  step_normalize(all_predictors())
  
#Logistic
glm_spec <- logistic_reg() %>% 
  set_engine("glm")
glm_spec

  
#RF

rf_spec <- rand_forest(mtry = tune(), min_n = tune(), trees = 1000) %>% 
  set_mode("classification") %>% 
  set_engine("ranger")

rf_rec <- recipe(formula = species ~ ., data = peng_train)

rf_workflow = workflow() %>% 
  add_recipe(rf_rec) %>% 
  add_model(rf_spec)

set.seed(111)
doParallel::registerDoParallel()

rf_rs <- tune_grid(rf_workflow,
                     resamples = peng_fold, 
                     grid = 11
                    )
rf_rs
show_best(rf_rs)


#KNN
knn_spec <- nearest_neighbor() %>% 
  set_mode("classification") %>% 
  set_engine("kknn")
knn_spec
=
  
