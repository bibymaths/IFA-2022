#' ---
#' title: "Project DS 1: Exploratory data analysis, and classifier training to predict condition using Cleveland Heart disease dataset."
#' author: "Abhinav Mishra"
#' date: " `r Sys.Date()`"  
#' output:
#'   pdf_document:
#'     latex_engine: lualatex 
#' --- 
 
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
if (!require("pacman", quietly = TRUE))
  install.packages("pacman")

pacman::p_load(tidyverse,
               skimr,
               ggvis,
               caret,
               MLeval,
               mice,
               RColorBrewer,
               ggplot2,
               ggpubr,
               GGally)

##----------------------------------------------------------------
##                  Loading data from the file                   -
##----------------------------------------------------------------

processedWithHeader_cleveland <-
  read_csv(
    "~/Documents/Freie/IFA/WiSe 22-23/Data Science/Week 2/processedWithHeader.cleveland.data",
    show_col_types = FALSE,
    na = "?"
  )

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

heart_data[heart_data$sex == 0,]$sex <- "F"
heart_data[heart_data$sex == 1,]$sex <- "M"
heart_data$sex <- as.factor(heart_data$sex)


heart_data[heart_data$goal == 0,]$goal <- "healthy"
heart_data[heart_data$goal == 1,]$goal <- "unhealthy"
heart_data[heart_data$goal == 2,]$goal <- "unhealthy"
heart_data[heart_data$goal == 3,]$goal <- "unhealthy"
heart_data[heart_data$goal == 4,]$goal <- "unhealthy"


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
  labs(title = 'Distribution plot') +
  xlab("Condition") 
 
###########################################################################
##                 Run this chunk after decommenting it                  ##
##               to get pair plots, grouped by sex and goal.             ##
##   It was creating problems in markdown generation so I commented it.  ##
###########################################################################

# ggscatmat(heart_data,
#           columns =
#             c('cp', 'ca', 'thal', 'thalach'),
#           color = "sex") + theme_classic() + labs(
#             x = "",
#             y = "",
#             title = "Pairplot",
#             subtitle = "Group: Sex"
#           )

# ggscatmat(heart_data,
#           columns =
#             c('cp', 'ca', 'thal', 'thalach'),
#           color = "goal") + theme_classic() + labs(
#             x = "",
#             y = "",
#             title = "Pairplot",
#             subtitle = "Group: Disease condition"
#           )


table(heart_data$goal)
round(prop.table(table(heart_data$goal)) * 100, digits = 1)

##----------------------------------------------------------------
##                          EDA: Heatmap                         -
##----------------------------------------------------------------
names <- c(
  "Age",
  "Sex",
  "Chest_Pain_Type",
  "Resting_Blood_Pressure",
  "Serum_Cholesterol",
  "Fasting_Blood_Sugar",
  "Resting_ECG",
  "Max_Heart_Rate_Achieved",
  "Exercise_Induced_Angina",
  "ST_Depression_Exercise",
  "Peak_Exercise_ST_Segment",
  "Num_Major_Vessels_Flouro",
  "Thalassemia",
  "Diagnosis_Heart_Disease"
)

colnames(data) <- names

data <- data %>% drop_na() %>%
  mutate_at(
    c(
      "Resting_ECG",
      "Fasting_Blood_Sugar",
      "Sex",
      "Diagnosis_Heart_Disease",
      "Exercise_Induced_Angina",
      "Peak_Exercise_ST_Segment",
      "Chest_Pain_Type"
    ),
    as_factor
  ) %>%
  mutate(Num_Major_Vessels_Flouro = as.numeric(Num_Major_Vessels_Flouro)) %>%
  mutate(Diagnosis_Heart_Disease = fct_lump(Diagnosis_Heart_Disease, other_level = "1")) %>%
  filter(Thalassemia != "?") %>%
  select(
    Age,
    Resting_Blood_Pressure,
    Serum_Cholesterol,
    Max_Heart_Rate_Achieved,
    ST_Depression_Exercise,
    Num_Major_Vessels_Flouro,
    everything()
  )

data.long <- data  %>%
  select(
    Sex,
    Chest_Pain_Type,
    Fasting_Blood_Sugar,
    Resting_ECG,
    Exercise_Induced_Angina,
    Peak_Exercise_ST_Segment,
    Thalassemia,
    Diagnosis_Heart_Disease
  ) %>%
  mutate(
    Sex = recode_factor(Sex, `0` = "female",
                        `1` = "male"),
    Chest_Pain_Type = recode_factor(
      Chest_Pain_Type,
      `1` = "typical",
      `2` = "atypical",
      `3` = "non-angina",
      `4` = "asymptomatic"
    ),
    Fasting_Blood_Sugar = recode_factor(Fasting_Blood_Sugar, `0` = "<= 120 mg/dl",
                                        `1` = "> 120 mg/dl"),
    Resting_ECG = recode_factor(
      Resting_ECG,
      `0` = "normal",
      `1` = "ST-T abnormality",
      `2` = "LV hypertrophy"
    ),
    Exercise_Induced_Angina = recode_factor(Exercise_Induced_Angina, `0` = "no",
                                            `1` = "yes"),
    Peak_Exercise_ST_Segment = recode_factor(
      Peak_Exercise_ST_Segment,
      `1` = "up-sloaping",
      `2` = "flat",
      `3` = "down-sloaping"
    ),
    Thalassemia = recode_factor(
      Thalassemia,
      `3` = "normal",
      `6` = "fixed defect",
      `7` = "reversible defect"
    )
  ) %>%
  gather(key = "key", value = "value",-Diagnosis_Heart_Disease)

data.long %>%
  ggplot(aes(value)) +
  geom_bar(
    aes(x        = value,
        fill     = Diagnosis_Heart_Disease),
    alpha    = .6,
    position = "dodge",
    color    = "black",
    width    = .8
  ) +
  labs(x = "",
       y = "",
       title = "Effect of Categorical Variables") +
  theme(axis.text.y  = element_blank(),
        axis.ticks.y = element_blank()) +
  facet_wrap( ~ key, scales = "free", nrow = 4) +
  scale_fill_manual(
    values = c("#F8766D", "#00BFC4"),
    name   = "Heart\nDisease",
    labels = c("No", "Yes")
  ) + theme_classic()

data.long.cont <- data  %>%
  select(
    Age,
    Resting_Blood_Pressure,
    Serum_Cholesterol,
    Max_Heart_Rate_Achieved,
    ST_Depression_Exercise,
    Num_Major_Vessels_Flouro,
    Diagnosis_Heart_Disease
  ) %>%
  gather(key   = "key",
         value = "value",-Diagnosis_Heart_Disease)

data.long.cont %>%
  ggplot(aes(y = value)) +
  geom_boxplot(aes(fill = Diagnosis_Heart_Disease),
               alpha  = .6,
               fatten = .7) +
  labs(x = "",
       y = "",
       title = "Boxplots for Numeric Variables") +
  scale_fill_manual(
    values = c("#F8766D", "#00BFC4"),
    name   = "Heart\nDisease",
    labels = c("No", "Yes")
  ) +
  theme(axis.text.x  = element_blank(),
        axis.ticks.x = element_blank()) +
  facet_wrap( ~ key,
              scales = "free",
              ncol   = 2) + theme_classic()

data %>% ggcorr(
  high       = "#00BFC4",
  low        = "#F8766D",
  label      = TRUE,
  hjust      = .75,
  size       = 3,
  label_size = 3,
  nbreaks    = 5
) +
  labs(title = "Heat Map", subtitle = "Pearson correlation") +
  theme_classic()

data %>% ggcorr(
  method     = c("pairwise", "kendall"),
  high       = "#00BFC4",
  low        = "#F8766D",
  label      = TRUE,
  hjust      = .75,
  size       = 3,
  label_size = 3,
  nbreaks    = 5
) +
  labs(title = "Heat Map", subtitle = "Kendall correlation") +
  theme_classic()

##----------------------------------------------------------------
##                        Data partition                         -
##----------------------------------------------------------------

test_index <- createDataPartition(
  y = heart_data$goal,
  times = 1,
  p = 0.2,
  list = FALSE
)
heart_data$goal <- as.factor(heart_data$goal)
train_data <- heart_data[-test_index,]
test_data <- heart_data[test_index,]



##---------------------------------------------------------------
##                          Classifiers                         -
##---------------------------------------------------------------

##---------------------------------------------------------------------------
##        1. Logistic regression: Fit the logistic regression model,        -
##   that is a GLM using a binomial link using the caret function train()   -
##---------------------------------------------------------------------------

set.seed(112)
log_fit <- train(goal ~ . - ID ,
                 data = train_data,
                 method = "glm",
                 family = "binomial")
log_pred <- predict(log_fit, test_data)
confusionMatrix(log_pred, test_data$goal)

##----------------------------------------------------------------
##                        2. Random forest                       -
##----------------------------------------------------------------

set.seed(112)
rf_fit <- train(goal ~ . - ID ,
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
blog_fit <- train(goal ~ . - ID,
                  data = train_data,
                  method = "LogitBoost")
blog_pred <- predict(blog_fit, test_data)
confusionMatrix(blog_pred, test_data$goal)

##----------------------------------------------------------------
##                            4. KNN                             -
##----------------------------------------------------------------

ctrl <-
  trainControl(method = "cv",
               verboseIter = FALSE,
               number = 5)

knn_fit <- train(
  goal ~ . - ID ,
  data = train_data,
  method = "knn",
  preProcess = c("center", "scale"),
  trControl = ctrl ,
  tuneGrid = expand.grid(k = seq(1, 20, 2))
)

plot(knn_fit, main = "K-nearest neighbour")

knn_pred <- predict(knn_fit, test_data)
confusionMatrix(knn_pred, test_data$goal)

results <- resamples(list(
  Logistic = log_fit,
  Random_Forest = rf_fit,
  Boosted_Logistic = blog_fit
))
summary(results)
dotplot(results)

cf_rf <- confusionMatrix(rf_pred, test_data$goal)
cf_log <- confusionMatrix(log_pred, test_data$goal)
cf_blog <- confusionMatrix(blog_pred, test_data$goal)
cf_knn <- confusionMatrix(knn_pred, test_data$goal)


##----------------------------------------------------------------
##                  Confusion Matrix as Heatmaps                 -
##----------------------------------------------------------------

A <-
  ggplot(as.tibble(as.table((cf_rf))), aes(x = Reference, y = Prediction, fill =
                                             n)) +
  geom_tile() + geom_text(aes(label = n), color = "white") +
  labs(title = "Random Forest model") + theme_classic()
B <-
  ggplot(as.tibble(as.table((cf_log))), aes(x = Reference, y = Prediction, fill =
                                              n)) +
  geom_tile() + geom_text(aes(label = n), color = "white") +
  labs(title = "Logistic model") + theme_classic()
C <-
  ggplot(as.tibble(as.table((cf_blog))), aes(x = Reference, y = Prediction, fill =
                                               n)) +
  geom_tile() + geom_text(aes(label = n), color = "white") +
  labs(title = "Boosted Logistic model") + theme_classic()
D <-
  ggplot(as.tibble(as.table((cf_knn))), aes(x = Reference, y = Prediction, fill =
                                              n)) +
  geom_tile() + geom_text(aes(label = n), color = "white") +
  labs(title = "kNN model") + theme_classic()

ggarrange(
  A,
  B,
  C,
  D,
  labels =
    c("1", "2", "3", "4"),
  ncol = 2,
  nrow = 2
)

##----------------------------------------------------------------
##                    Performance Comparison                     -
##----------------------------------------------------------------

Accuracy <- 100 * rbind(cf_log[["overall"]][["Accuracy"]],
                        cf_rf[["overall"]][["Accuracy"]],
                        cf_blog[["overall"]][["Accuracy"]],
                        cf_knn[["overall"]][["Accuracy"]])

Specificity <- 100 * rbind(cf_log[["byClass"]][["Specificity"]],
                           cf_rf[["byClass"]][["Specificity"]],
                           cf_blog[["byClass"]][["Specificity"]],
                           cf_knn[["byClass"]][["Specificity"]])

Sensitivity <- 100 * rbind(cf_log[["byClass"]][["Sensitivity"]],
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

y <- barplot(
  pf_result,
  beside = TRUE,
  horiz = TRUE,
  col = brewer.pal(3, "Set1"),
  border = "white",
  legend.text = c("Accuracy", "Specificity", "Sensitivity"),
  args.legend = list(bty = "n", cex = 0.4),
  xlim = c(0, 100),
  main = "Performance Chart",
  ylab = "Method"
)

x <- round(pf_result)

text(x + 2, y, labels = as.character(x))



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

cont <- trainControl(
  method = "cv",
  summaryFunction = twoClassSummary,
  classProbs = T,
  savePredictions = T
)

log <- train(
  goal ~ . - ID ,
  data = train_data,
  method = "glm",
  preProc = c("center", "scale"),
  family = "binomial",
  trControl = cont
)

rf <- train(
  goal ~ . - ID ,
  data = train_data,
  preProc = c("center", "scale"),
  method = "rf",
  trControl = cont
)

blog <- train(
  goal ~ . - ID,
  data = train_data,
  preProc = c("center", "scale"),
  method = "LogitBoost",
  trControl = cont
)


knn <- train(
  goal ~ . - ID ,
  data = train_data,
  method = "knn",
  preProcess = c("center", "scale"),
  trControl = cont ,
  tuneGrid = expand.grid(k = seq(1, 20, 2))
)



#################################################################
##                           AUC-ROC                           ##
#################################################################
metric <- evalm(
  list(log, rf, blog, knn),
  gnames = c('Logistic', 'Random Forest',
             'Boosted Logistic', 'kNN'),
  rlinethick = 0.8,
  fsize = 8,
  silent = TRUE
)

ROC <- data.frame(round(rbind(log[["results"]][["ROC"]],
                              max(rf[["results"]][["ROC"]]),
                              max(blog[["results"]][["ROC"]]),
                              max(knn[["results"]][["ROC"]])), 2))

colnames(ROC) <- "AUC-ROC"
row.names(ROC) <-
  c("Logistic", "Random Forest", "Boosted Logit", "kNN")

ROC
##---------------------------------------------------------------
##                              EOL                             -
##---------------------------------------------------------------
