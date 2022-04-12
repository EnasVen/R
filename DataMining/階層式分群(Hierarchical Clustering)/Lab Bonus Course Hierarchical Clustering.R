#### Lab Bonus Course Hierarchical Clustering ####
# referenece web https://uc-r.github.io/hc_clustering #

library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering visualization
library(dendextend) # for comparing two dendrograms

#### 使用 hclust 套件內的 agnes 函數 ####

# cluster 套件內 函數agnes用來做Agglomerative ; diana 用來做 divisive
data("USArrests")
head(USArrests, 10)

# data prepare
df <- na.omit(USArrests)

df <- scale(df)
head(df)

# Dissimilarity matrix
d <- dist(df, method = "euclidean")

# Hierarchical clustering using Complete Linkage
hc1 <- hclust(d, method = "complete" )

# Plot the obtained dendrogram
plot(hc1, cex = 0.6, hang = -1)


# Compute with agnes
hc2 <- agnes(df, method = "complete")

# Agglomerative coefficient 用來衡量分群辨識度高低，越小越好!
# 計算每一樣本點到所有群的不相似度 #
hc2$ac

# methods to assess
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

# function to compute coefficient
ac <- function(x) {
  agnes(df, method = x)$ac
}

map_dbl(m, ac)

hc3 <- agnes(df, method = "ward")
pltree(hc3, cex = 0.6, hang = -1, main = "Dendrogram of agnes")



#### 使用 stats 套件內的 hclust 函數 ####

# Ward's method
hc5 <- hclust(d, method = "ward.D2" )

# Cut tree into 4 groups
sub_grp <- cutree(hc5, k = 4)

# Number of members in each cluster
table(sub_grp)


USArrests %>%
  mutate(cluster = sub_grp) %>%
  head

plot(hc5, cex = 0.6)
rect.hclust(hc5, k = 4, border = 2:5)


# Compute distance matrix
res.dist <- dist(df, method = "euclidean")

# Compute 2 hierarchical clusterings
hc1 <- hclust(res.dist, method = "complete")
hc2 <- hclust(res.dist, method = "ward.D2")

# Create two dendrograms
dend1 <- as.dendrogram (hc1)
dend2 <- as.dendrogram (hc2)

tanglegram(dend1, dend2)



#### 使用 factorextra 套件內的 fviz_nbclust 函數 ####

# 使用 with-in sum of squares 來畫圖，決定分群數目
fviz_nbclust(df, FUN = hcut, method = "wss")

# 使用 silhouette值 來畫圖，決定分群數目
fviz_nbclust(df, FUN = hcut, method = "silhouette")
