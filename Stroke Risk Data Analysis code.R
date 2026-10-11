# Load required libraries
library(caret)
library(pROC)
library(ggplot2)
library(MASS)
library(e1071)
library(rpart)
library(rpart.plot)
library(Metrics)

stroke = read.csv("healthcare-dataset-stroke-data.csv", header = TRUE)

head(stroke)

# Convert response variable to factor
stroke$stroke = as.factor(stroke$stroke)

# Convert relevant categorical variables (based on dictionary)
stroke$gender = as.factor(stroke$gender)
stroke$ever_married = as.factor(stroke$ever_married)
stroke$work_type = as.factor(stroke$work_type)
stroke$Residence_type = as.factor(stroke$Residence_type)
stroke$smoking_status = as.factor(stroke$smoking_status)
stroke$hypertension = as.factor(stroke$hypertension)
stroke$heart_disease = as.factor(stroke$heart_disease)
stroke$age = as.numeric(stroke$age)
stroke$avg_glucose_level = as.numeric(stroke$avg_glucose_level)
stroke$bmi = as.numeric(stroke$bmi)

# Handle missing BMI values
stroke$bmi[is.na(stroke$bmi)] = mean(stroke$bmi, na.rm = TRUE)

# Use only first 2000 rows
stroke = stroke[1:2000, ]

# Remove ID column if present
stroke = stroke[, !(names(stroke) %in% c("id"))]


# Train/Test Split
n = nrow(stroke)
set.seed(401)

train.index = sample(n, 0.7*n)
train = stroke[train.index, ]
test = stroke[-train.index, ]

# Logistic Regression Models

# Simple model (example with age)
glm1 = glm(stroke ~ age, family = binomial, data = train)
summary(glm1)

# Prediction examples
predict(glm1, data.frame(age = 50), type = "response")
predict(glm1, data.frame(age = 70), type = "response")

# Full model (key predictors based on dataset)
glm2 = glm(stroke ~ age + hypertension + heart_disease + work_type + gender
           + avg_glucose_level + bmi + smoking_status + Residence_type + ever_married, 
           family = binomial, data = train)

summary(glm2)


# Predictions
glm.prob = predict(glm2, test, type = "response")
glm.prob[1:5]

test.n = nrow(test)

glm.class = rep(0, test.n)
glm.class[glm.prob > 0.2] = 1

glm.class = as.factor(glm.class)

# Confusion Matrix
confusionMatrix(data = glm.class, reference = test$stroke, positive = "1")


# ROC Curve & AUC
glm.roc = roc(response = test$stroke, predictor = glm.prob)

auc(glm.roc)

plot(glm.roc, main = "ROC Curve for Stroke")

# ggplot
stroke$risk = as.numeric(as.character(stroke$stroke))

ggplot(stroke, aes(x = age, y = risk)) +
  geom_point(alpha = 0.2) +
  stat_smooth(method = "glm", method.args = list(family = "binomial")) +
  ggtitle("Stroke Risk vs Age")

ggplot(stroke, aes(x = bmi, y = risk)) +
  geom_point(alpha = 0.2) +
  stat_smooth(method = "glm", method.args = list(family = "binomial")) +
  ggtitle("Stroke Risk vs BMI")

ggplot(stroke, aes(x = avg_glucose_level, y = risk)) +
  geom_point(alpha = 0.2) +
  stat_smooth(method = "glm", method.args = list(family = "binomial")) +
  ggtitle("Stroke Risk vs Glucose Level")

ggplot(stroke, aes(x = hypertension, y = risk)) +
  stat_summary(fun = mean, geom = "bar") +
  ggtitle("Stroke Risk by Hypertension")

ggplot(stroke, aes(x = heart_disease, y = risk)) +
  stat_summary(fun = mean, geom = "bar") +
  ggtitle("Stroke Risk by Heart Disease")

ggplot(stroke, aes(x = work_type, y = risk)) +
  stat_summary(fun = mean, geom = "bar") +
  ggtitle("Stroke Risk by Employment Type")

         ####### KNN-Analysis #######
data <- read.csv("healthcare-dataset-stroke-data.csv", header = TRUE)

data$id <- NULL

# Make sure numeric variables are numeric
data$age <- as.numeric(data$age)
data$avg_glucose_level <- as.numeric(data$avg_glucose_level)
data$bmi <- as.numeric(data$bmi)

# Impute missing BMI
data$bmi[is.na(data$bmi)] <- median(data$bmi, na.rm = TRUE)

# Convert categorical variables to factors
data$stroke <- as.factor(data$stroke)
data$gender <- as.factor(data$gender)
data$ever_married <- as.factor(data$ever_married)
data$work_type <- as.factor(data$work_type)
data$Residence_type <- as.factor(data$Residence_type)
data$smoking_status <- as.factor(data$smoking_status)
data$hypertension <- as.factor(data$hypertension)
data$heart_disease <- as.factor(data$heart_disease)

# Handle missing BMI
data$bmi[is.na(data$bmi)] = median(data$bmi, na.rm = TRUE)

#### Train/test split
set.seed(401)
n <- nrow(data)

train.index <- sample(n, 0.7 * n)
train_data <- data[train.index, ]
test_data  <- data[-train.index, ]

ctrl <- trainControl(method = "cv", number = 5)

set.seed(41)
model <- train(
  stroke ~ age + hypertension + heart_disease + avg_glucose_level + bmi +
    gender + ever_married + work_type + Residence_type + smoking_status,
  data = train_data,
  method = "knn",
  preProcess = c("center", "scale"),
  tuneGrid = expand.grid(k = seq(1, 19, 2)),
  trControl = ctrl
)

pred.class <- predict(model, newdata = test_data)
pred.prob <- predict(model, newdata = test_data, type = "prob")

## Confusion matrix
confusionMatrix(
  data = pred.class,
  reference = test_data$stroke,
  positive = "1"
)


## Box plots for numeric variables
numeric_vars <- c("age", "avg_glucose_level", "bmi")

# Set plotting layout
par(mfrow = c(1, 3))

for (var in numeric_vars) {
  boxplot(
    test_data[[var]] ~ test_data$stroke,
    main = paste(var, "by Stroke"),
    xlab = "Stroke (0 = No, 1 = Yes)",
    ylab = var,
    col = c("lightblue", "salmon")
  )
}

# Reset layout
par(mfrow = c(1,1))


# Bar plots for categorical variables
categorical_vars <- c("gender", "ever_married", "work_type", 
                      "Residence_type", "smoking_status",
                      "hypertension", "heart_disease")

for (var in categorical_vars) {
  
  # Increase bottom margin for long labels
  par(mar = c(10, 4, 4, 2))
  
  tbl <- table(test_data[[var]], test_data$stroke)
  prop_tbl <- prop.table(tbl, 1)
  
  barplot(
    t(prop_tbl),
    beside = TRUE,
    col = c("lightblue", "salmon"),
    legend.text = c("No Stroke", "Stroke"),
    args.legend = list(x = "topright", bty = "n"),
    main = paste("Stroke Outcome by", var),
    xlab = var,
    ylab = "Proportion",
    las = 2,
    cex.names = 0.8
  )
  
  # Pause for viewing each plot one-by-one
  readline(prompt = "Press [Enter] to continue...")
}

# Reset margins after loop
par(mar = c(5, 4, 4, 2))

         ##### Decision Trees #####
stroke = read.csv("healthcare-dataset-stroke-data.csv", header=T, stringsAsFactors=FALSE)

stroke$age = as.numeric(stroke$age)
stroke$bmi = as.numeric(stroke$bmi)
stroke$avg_glucose_level = as.numeric(stroke$avg_glucose_level)
stroke$hypertension = as.numeric(stroke$hypertension)
stroke$heart_disease = as.numeric(stroke$heart_disease)

stroke$bmi[is.na(stroke$bmi)] = median(stroke$bmi, na.rm=TRUE)

stroke$gender = as.factor(stroke$gender)
stroke$ever_married = as.factor(stroke$ever_married)
stroke$work_type = as.factor(stroke$work_type)
stroke$Residence_type = as.factor(stroke$Residence_type)
stroke$smoking_status = as.factor(stroke$smoking_status)
stroke$stroke = as.factor(stroke$stroke)

stroke$id = NULL

n = nrow(stroke)
set.seed(1949)
train.index = sample(n, 0.7*n)
train = stroke[train.index,]
test  = stroke[-train.index,]

set.seed(138)
cv.ct = rpart(stroke~., data=train, method="class",
              control = rpart.control(maxdepth=4, minsplit=20, cp=0.01))

# Save tree plot to file - heavy overfitting issues
png("tree_plot.png", width=1200, height=800, res=120)
rpart.plot(cv.ct, extra=1, fallen.leaves=F, cex=0.8, tweak=1.2)
dev.off()

pred.class = predict(cv.ct, test, type="class")
pred.prob = predict(cv.ct, test, type="prob")

# Confusion matrix
confusionMatrix(as.factor(pred.class), as.factor(test$stroke))
