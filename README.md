# IFA-2022
# Group 7: Maike, Jule, Abhinav, Se Yeon Kim

## Background 
 
We used the [Heart Disease Data Set](https://archive.ics.uci.edu/ml/datasets/Heart+Disease) from the Cleveland Database. This database contains clinical and bio-medical attributes for more than 300 patients. The "goal" field refers to the presence of a heart disease in a patient. It is integer valued from 0 (no presence) to 4.   

## Week 1 

We have performed exploratory data analysis on the Cleveland heart disease dataset described above, and trained machine learning models to diagnose heart disease based on the available data and compare them visually in a grouped bar chart with regard to accuracy, sensitivity and specificity, along with confusion matrix for each classifier in python, and R. 

### R script  
 
**Packages**: tidyverse, skimr, ggvis, caret, ggvis, caret, MLeval   
 
**Note**: _Boosted logistics is using decision stumps (one node decision trees) as weak learners. It implements a internal version of decision stump classifier instead of using calls to rpart. Also, training and testing phases of the classification process are split into separate functions._
 
#### Steps 
 
1. Loading the processed dataset using _read_csv()_. 
2. Removing NA values using _na.omit()_. 
3. Passing some attributes as _factors_. 
4. Tidying up the data: _healthy_ to 0, and _unhealthy_ to 1-4 in the column _goal_. 
5. Getting to know the data via descriptive statistics. 
6. Understanding, and visualization for the distribution of patients in the above category. 
7. Scatter plots by: condition, sex, and chest pain. 
8. Dividing the data for ML training, and test set. 
9. Training the model with classifiers used: logistic, random forest, boosted logistic, and kNN using _train()_ from _caret_ package. 
10. Performance comparison, and feature extraction from each model.  
11. Performance plots as a measure for model evaluation with ROC, calibration, precision recall gain, and Obs vs. Pred probabilities curve. 




 
 

