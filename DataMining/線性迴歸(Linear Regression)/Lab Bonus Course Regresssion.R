#### Lab Bonus Course Linear Regression####

# Use iris dataset to construct lm model
data(iris)
md <- lm(Sepal.Length ~ . ,data = iris %>% dplyr::select(-Species) )
summary(md)

# Verify Results :

# beta estimators
design.matrix <- as.matrix(cbind(1,iris %>% dplyr::select(-Sepal.Length,-Species)))  # 150 x 4 matrix
beta.verify <- solve(t(design.matrix )%*% design.matrix)%*%t(design.matrix) %*% iris$Sepal.Length # 4 x 1 vector

# sigma estimator
sigma.verify <- sqrt( t(iris$Sepal.Length-design.matrix %*% beta.verify ) %*% (iris$Sepal.Length-design.matrix %*% beta.verify ) / (150-(3+1)) )

# std.error of beta estimators
sqrt(  diag(solve(t(design.matrix )%*% design.matrix)) * sigma.verify**2 )


#SSE - sum(actual - predicted^2)
SSE <- sum(md$residuals^2)

#SSR - sum(predicted - ybar^2)
ybar <- mean(iris$Sepal.Length)
SSR <- sum((md$fitted.values-ybar)^2)

#SST - sum((y - ybar)^2) / SSE+SSR
SST <- SSE+SSR

# R square
SSR/SST

# Adjust R Square
1-((SSE/(150-(3+1)))/(SST/(150-1)))
