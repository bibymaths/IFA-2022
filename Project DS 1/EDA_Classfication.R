##--------------------------------------------------------------------
##            A script for exploratory data analysis, and            -
##             classification training four classifiers             -
##   to diagnose heart disease based on the Heart Disease Data Set   -
##-------------------------------------------------------------------- 
#################################################################
##                   Author: Abhinav Mishra                    ##
################################################################# 
 
##----------------------------------------------------------------
##              Loading/Installing packages required             -
##----------------------------------------------------------------
 
#install.packages(c("MLeval", caret", "ggvis", 
# "skimr", "tidyverse","ggvis", "e1071", "RColorBrewer")) 

library(tidyverse)
library(skimr)  
library(ggvis) 
library(caret) 
library(ggvis)
library(caret) 
library(MLeval) 
library(RColorBrewer)
 
##----------------------------------------------------------------
##                  Loading data from the file                   -
##----------------------------------------------------------------

processedWithHeader_cleveland <- read_csv("~/Documents/Freie/IFA/WiSe 22-23/Data Science/Week 2/processedWithHeader.cleveland.data",  
                                          show_col_types = FALSE, na = "?") 

heart_data <- na.omit(data.frame(processedWithHeader_cleveland))
data <- data.frame(processedWithHeader_cleveland)
heart_data$ID <- seq.int(nrow(heart_data)) 
 
##----------------------------------------------------------------
##                      Passing as factors                       -
##----------------------------------------------------------------

#
heart_data$fbs <- as.factor(heart_data$fbs)
heart_data$restecg <- as.factor(heart_data$restecg)
heart_data$exang <- as.factor(heart_data$exang)
heart_data$slope <- as.factor(heart_data$slope)
#heart_data$cp <- as.factor(heart_data$cp) 
 
##---------------------------------------------------------------
##                Data wrangling with preparation               -
##---------------------------------------------------------------

heart_data[heart_data$sex == 0, ]$sex <- "F"
heart_data[heart_data$sex == 1, ]$sex <- "M"
heart_data$sex <- as.factor(heart_data$sex)


heart_data[heart_data$goal == 0, ]$goal <- "healthy"
heart_data[heart_data$goal == 1, ]$goal <- "unhealthy" 
heart_data[heart_data$goal == 2, ]$goal <- "unhealthy" 
heart_data[heart_data$goal == 3, ]$goal <- "unhealthy" 
heart_data[heart_data$goal == 4, ]$goal <- "unhealthy"


write.table(heart_data, file = 'heart_data') 
table(heart_data$goal)


##---------------------------------------------------------------
##            Descriptive Statistics + NA values omit           -
##---------------------------------------------------------------

str(heart_data)             
summary(heart_data)         
sum(is.na(heart_data))       


##---------------------------------------------------------------
##                      Descriptive plots                       -
##--------------------------------------------------------------- 

ggplot(heart_data, aes(x = goal, fill = goal)) +
  geom_bar() + theme_classic() +  
  labs(title='Distribution plot') +  
  xlab("Condition")  


table(heart_data$goal)
round(prop.table(table(heart_data$goal)) * 100, digits = 1)
 
##----------------------------------------------------------------
##                  Scatter plots by condition                   -
##----------------------------------------------------------------
 
#heart_data %>% ggvis(~age, ~trestbps, fill = ~goal) %>% layer_points() 

#heart_data %>% ggvis(~age, ~trestbps, fill = ~sex) %>% layer_points()

#heart_data %>% ggvis(~age, ~trestbps, fill = ~ cp) %>% layer_points()

##----------------------------------------------------------------
##                        Data partition                         -
##---------------------------------------------------------------- 

test_index <- createDataPartition(y = heart_data$goal, times = 1,  
                                  p = 0.2, list= FALSE)  
heart_data$goal <- as.factor(heart_data$goal) 
train_data <- heart_data[-test_index, ]
test_data <- heart_data[test_index, ]   



##---------------------------------------------------------------
##                          Classifiers                         -
##--------------------------------------------------------------- 

##---------------------------------------------------------------------------
##        1. Logistic regression: Fit the logistic regression model,        -
##   that is a GLM using a binomial link using the caret function train()   -
##---------------------------------------------------------------------------

set.seed(112)
log_fit <- train(goal ~.-ID ,
                 data = train_data,  
                 method = "glm",  
                 family = "binomial")  
log_pred <- predict(log_fit, test_data)
confusionMatrix(log_pred, test_data$goal)
 
##----------------------------------------------------------------
##                        2. Random forest                       -
##----------------------------------------------------------------

set.seed(112)
rf_fit <- train(goal ~.-ID ,
                    data = train_data,  
                    method = "rf")

rf_pred <- predict(rf_fit, test_data) 
confusionMatrix(rf_pred, test_data$goal)

##--------------------------------------------------------------------------------------
##  3. Boosted logistic regression: using decision stumps (one node decision trees)    -
##           as weak learners. It implements a internal version of decision            -
##                          stump classifier instead of using                          -
##               calls to rpart. Also, training and testing phases of the              -
##              classification process are split into separate functions.              -
##--------------------------------------------------------------------------------------

set.seed(112)
blog_fit <- train(goal ~.-ID,
                   data = train_data,  
                   method = "LogitBoost")
blog_pred <- predict(blog_fit, test_data) 
confusionMatrix(blog_pred, test_data$goal)  
 
##----------------------------------------------------------------
##                            4. KNN                             -
##---------------------------------------------------------------- 
 
ctrl <- trainControl(method = "cv", verboseIter = FALSE, number = 5) 

knn_fit <- train(goal ~. -ID , data = train_data,  
                method = "knn", preProcess = c("center","scale"),
                trControl = ctrl , tuneGrid = expand.grid(k = seq(1, 20, 2)))

plot(knn_fit, main = "K-nearest neighbour")

knn_pred <- predict(knn_fit, test_data) 
confusionMatrix(knn_pred, test_data$goal)

 
##----------------------------------------------------------------
##                    Performance Comparison                     -
##---------------------------------------------------------------- 

results <- resamples(list(Logistic = log_fit,  
                          Random_Forest = rf_fit,  
                          Boosted_Logistic = blog_fit))
summary(results)
dotplot(results)
 
cf_rf <- confusionMatrix(rf_pred, test_data$goal) 
cf_log <- confusionMatrix(log_pred, test_data$goal) 
cf_blog <- confusionMatrix(log_pred, test_data$goal)  
cf_knn <- confusionMatrix(knn_pred, test_data$goal)
  
Accuracy <- 100*rbind(cf_log[["overall"]][["Accuracy"]],  
             cf_rf[["overall"]][["Accuracy"]],  
             cf_blog[["overall"]][["Accuracy"]],  
             cf_knn[["overall"]][["Accuracy"]])  

Specificity <- 100*rbind(cf_log[["byClass"]][["Specificity"]],  
              cf_rf[["byClass"]][["Specificity"]],  
              cf_blog[["byClass"]][["Specificity"]], 
              cf_knn[["byClass"]][["Specificity"]]) 
 
Sensitivity <- 100*rbind(cf_log[["byClass"]][["Sensitivity"]], 
              cf_rf[["byClass"]][["Sensitivity"]], 
              cf_blog[["byClass"]][["Sensitivity"]], 
              cf_knn[["byClass"]][["Sensitivity"]])   

pf_result <- t(data.frame(Accuracy, Specificity, Sensitivity)) 
colnames(pf_result) <- c("Log", "RF", "LogitB", "KNN") 
pf_result <- as.matrix(pf_result)  
pf_result 

plot(rf_fit, main = "Random Forest")  
plot(blog_fit, main = "Boosted Logistic") 
plot(knn_fit, main = "K-nearest neighbour")  

y <- barplot(pf_result, beside = TRUE, horiz = TRUE, 
             col=brewer.pal(3,"Set1"),border="white",  
             legend.text = c("Accuracy", "Specificity", "Sensitivity"),  
             args.legend = list(bty = "n", cex = 0.3), xlim=c(0,100),  
             main = "Performance Chart", ylab = "Method")  

x <- round(pf_result) 

text(x+2,y,labels=as.character(x))

 

##----------------------------------------------------------------
##                      Feature extraction                       -
##---------------------------------------------------------------- 

feat_log <- varImp(log_fit, scale = FALSE) 
feat_rf <- varImp(rf_fit, scale = FALSE) 
feat_blog <- varImp(blog_fit, scale = FALSE)   
feat_knn <- varImp(knn_fit, scale = FALSE) 

plot(feat_log, main = "Logistic regression: features")  
plot(feat_rf, main = "Random forest: features")  
plot(feat_blog, main = "Boosted Logistic regression: features") 
plot(feat_knn, main = "KNN: features")  
  
##----------------------------------------------------------------
##      Model Evaluation with ROC, calibration, precision        -
##       recall gain, and Obs vs. Pred probabilities curve       -
##---------------------------------------------------------------- 

cont <- trainControl(method="cv", 
                     summaryFunction=twoClassSummary, 
                     classProbs=T,
                     savePredictions = T)    

log <- train(goal ~.-ID ,
                 data = train_data,  
                 method = "glm", preProc=c("center", "scale"), 
                 family = "binomial", trControl=cont)  

rf <- train(goal ~.-ID ,
                data = train_data, preProc=c("center", "scale"), 
                method = "rf", trControl=cont) 
 
blog <- train(goal ~.-ID,
              data = train_data, preProc=c("center", "scale"),
              method = "LogitBoost", trControl=cont)
   
 
knn <- train(goal ~. -ID , data = train_data,  
             method = "knn", preProcess = c("center","scale"),
             trControl = cont , tuneGrid = expand.grid(k = seq(1, 20, 2))) 

#################################################################
##            Logistic Classifier: Performance Plots            ##
#################################################################  
res.log <- evalm(log)  
##################################################################
##          Random Forest Classifier: Performance Plots          ##
################################################################## 
res.rf <- evalm(rf)
##################################################################
##          Boosted logit Classifier: Performance Plots          ##
################################################################## 
res.blog <- evalm(blog) 
#################################################################
##              k-NN Classifier: Performance Plots              ##
#################################################################
res.knn <- evalm(knn) 

