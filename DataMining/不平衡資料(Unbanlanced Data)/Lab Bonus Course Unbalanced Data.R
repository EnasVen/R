### Simulation of Unbalanced Data ###
#### Referenece website : https://topepo.github.io/caret/subsampling-for-class-imbalances.html ###

### Update R ###
upd = function(){
  if(!require(installr)) {
    install.packages("installr");
    require(installr)
  }
  updateR()
}
upd()

rm(list=ls())


#### Subsampling ####

# simulation data
library(caret)
set.seed(2969)
imbal_train <- twoClassSim(10000, intercept = -20, linearVars = 20)
imbal_test  <- twoClassSim(10000, intercept = -20, linearVars = 20)
table(imbal_train$Class)

# down sampling
set.seed(9560)
down_train <- downSample(x = imbal_train[, -ncol(imbal_train)],
                         y = imbal_train$Class)
table(down_train$Class)

# up sampling
set.seed(9560)
up_train <- upSample(x = imbal_train[, -ncol(imbal_train)],
                     y = imbal_train$Class)
table(up_train$Class)

# SMOTE
library(DMwR)
set.seed(9560)
smote_train <- SMOTE(Class ~ ., data  = imbal_train)
table(smote_train$Class)

# ROSE
library(ROSE)
set.seed(9560)
rose_train <- ROSE(Class ~ ., data  = imbal_train)$data
table(rose_train$Class)

### 設定建模控制變因 ###

ctrl <- trainControl(method = "repeatedcv", repeats = 5,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary)

set.seed(5627)
orig_fit <- train(Class ~ ., data = imbal_train,
                  method = "treebag",
                  nbagg = 50,
                  metric = "ROC",
                  trControl = ctrl)

set.seed(5627)
down_outside <- train(Class ~ ., data = down_train,
                      method = "treebag",
                      nbagg = 50,
                      metric = "ROC",
                      trControl = ctrl)

set.seed(5627)
up_outside <- train(Class ~ ., data = up_train,
                    method = "treebag",
                    nbagg = 50,
                    metric = "ROC",
                    trControl = ctrl)

set.seed(5627)
rose_outside <- train(Class ~ ., data = rose_train,
                      method = "treebag",
                      nbagg = 50,
                      metric = "ROC",
                      trControl = ctrl)


set.seed(5627)
smote_outside <- train(Class ~ ., data = smote_train,
                       method = "treebag",
                       nbagg = 50,
                       metric = "ROC",
                       trControl = ctrl)

# Save models
outside_models <- list(original = orig_fit,
                       down = down_outside,
                       up = up_outside,
                       SMOTE = smote_outside,
                       ROSE = rose_outside)

# 進行多次實驗，確認訓練模型的performance
outside_resampling <- resamples(outside_models)

# 使用ROC衡量各模型表現，並計算其roc的信賴區間
test_roc <- function(model, data) {
  library(pROC)
  roc_obj <- roc(data$Class,
                 predict(model, data, type = "prob")[, "Class1"],
                 levels = c("Class2", "Class1"))
  ci(roc_obj)
}

outside_test <- lapply(outside_models, test_roc, data = imbal_test)
outside_test <- lapply(outside_test, as.vector)
outside_test <- do.call("rbind", outside_test)
colnames(outside_test) <- c("lower", "ROC", "upper")
outside_test <- as.data.frame(outside_test)

summary(outside_resampling, metric = "ROC")
outside_test
