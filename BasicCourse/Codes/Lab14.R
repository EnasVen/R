######################################
####   CH14 - Data Manipulation   ####
######################################

#### CH 14.1 : Basic Operation ####

#### CH 14.1 : Basic Operation : Recoding ####
v1 <- sample(1:100 , 15 , replace=F) ; v1
v2 <- 1*(v1>=90)+2*(v1<90 & v1 >=60)+3*(v1<60) ; v2  #  use vector to symbolized each element
tags <- c('高分','普通','不及格')
v3 <-  tags[v2] ; v3  #  use indexing skill to recode

#### CH 14.1 : Basic Operation : If-Else ####
ifelse(v1>=90 , '高分' , ifelse(v1<90 & v1>=60 , '普通' ,'不及格'))  #  use if-else to recode binary category

#### CH 14.1 : Basic Operation : Cut ####
cut(v1 , breaks = c(0 , 60 , 90 , Inf) , labels = c('不及格','普通',"高分") , right = T)  #  cat can only be applied to numeric data

#### CH 14.1 : Basic Operation : Recode ####
library(car)
car::recode(v1 , recodes = "lo:60='不及格' ; 60:90='普通' ; 90:hi='高分'")  #  use car::recode to avoid confounding with dplyr::recode

#### CH 14.1 : Basic Operation : Ordering ####
sort(c(1.45,0.883,-25.32,100) , decreasing = F )  #  return ordered data
rank(c(1.45,0.883,-25.32,100))  # return ranking number
order(x <<- c(1.45,0.883,-25.32,100)) ; x[order(x)]  #  return position number
rev(x)  # up-side-down

#### CH 14.1 : Basic Operation : Data type conversion ####
as.character(1)  #   It has been introduced in the previous part . Use as.xxx(...) func. to handle

# stack
stack(mtcars)  #  overlay data into two cols
unstack(stack(mtcars) )

# Long / Wide Transform
if(!'reshape2' %in% installed.packages()){install.packages('reshape2')}else{cat('Already installed !')}
library(reshape2)
aqm <- melt(airquality, id.vars = c("Month", "Day") , na.rm = T)
head(aqm)

dcast(aqm, Month ~ variable, mean , subset = .(value >= 40)) # Error occurrs becuz no plyr package
if(!'plyr' %in% installed.packages()){install.packages('plyr')}else{cat('Already installed !')}
library(plyr)
dcast(aqm, Month ~ variable, mean , subset = .(value >= 40))  #  subset func. need plyr package
dcast(aqm, Month ~ variable, mean , subset = .(value >= 40 , variable == 'Ozone'))
dcast(aqm, Month ~ variable, mean , subset = .(value >= 40 , variable != 'Ozone'))
dcast(aqm, Month ~ variable, mean , subset = .(value >= 40 , variable == c('Ozone','Temp')))

#### CH 14.1 : Basic Operation : Basic Integration ####

# vector combination
a<- c(1,2,3) ; b <- c(4,5,6)
c(a,b) == union(a,b)
rbind(a,b) ; cbind(a,b)

# d.f. combination
a<- mtcars[1:3,c(1,3)] ; b <- mtcars[1:3,c(2,3,5,6)]
rbind(a,b)

c <- mtcars[1:5,c(1,4)]
cbind(a,c)

#### CH 14.1 : Basic Operation : Advanced Integration ####

# Merge func.
a<- mtcars[1:3,c(1,3)] ; b <- mtcars[1:3,c(2,3,5,6)]
a <- cbind('Name' = rownames(a) , a )
b <- cbind('Name' = rownames(b) , b )
merge(a , b , by.x = c("Name" , "disp") , all.x = T)  # it's similar to join func. in SQL

colnames(b)[c(1,3)] <- c("Name2","disp2")
merge(a , b , by.x = c("Name","disp") , by.y = c("Name2","disp2") , all.x = T) #  assign cols to merge when there exist no common col

#### CH 14.1 : Basic Operation : Split ####

# split
tmp.list <- split(mtcars , mtcars$gear)  #  use certain col to split data
tmp.list[1]

# Subset
subset(mtcars , mpg > 20.33 ,  select = -cyl)
subset(mtcars , drat <= 3.25 ,  select = hp:qsec)  #  Noted that this subset is in base package , not plyr

# Indexing
mtcars[1:2,c(1,3,5)]

# Logical
tmp.matrix <- matrix(rnorm(9,1,10) , ncol=3)
tmp.matrix[tmp.matrix > 5]
mtcars[which(mtcars$mpg>30),]

iris[which(iris$Species %in% c('setosa')),"Petal.Width"]  #  we can use %in% operation to filter

'%not-in%' <- function(x,y) !x %in% y   # custom operator

# Random Sampling
idx <- sample(1:nrow(airquality) , 15 , replace = F)
airquality[idx,]

#### ___________________________________________________________ ####
#### CH 14.2 : Grouping Operation ####

#### CH 14.2 : Grouping Operation : Apply Family ####

# apply
apply( airquality , 2 , sum)  # find column sum ; 2 means colwise while 1 refers to rowwise
apply( airquality , 2 , sum , na.rm=T)
colSums(airquality , na.rm = T)  #  col/rowSums can directly calculate summation

# lapply
x <- list(a = 1:10, beta = exp(-3:3), logic = c(TRUE,FALSE,FALSE,TRUE))
lapply( x , FUN = sum)  #  lapply returns list

# sapply
sapply( x , FUN = sum)  #  sapply returns vector
is.vector(sapply( x , FUN = sum))
sapply( airquality , FUN = mean)
sapply(airquality , sum , na.rm=T)

# mapply
# mapply(rep, 1:4, 4:1)  #  return list
# mapply(rep, times = 1:4, MoreArgs = list(x = 42))  #  return list
#
# list.a <- list(c(1,2,3,4) , c(1,2))
# list.b <- list(c(1,5) , c(2,4,6,8,10))
# mapply( function(x,y) max(length(x) , length(y)) , list.a , list.b)  #  vector type input to func.
# mapply(function(x,y) x^y, c(1:5), c(1:5))  #  vector type input to func.
# mapply(function(x, y) seq_len(x) + y,
#        c(a =  1, b = 2, c = 3),
#        c(A = 10, B = 0, C = -10))  #  vector type input to func.


#### CH 14.2 : Grouping Operation : Aggregate ####

testDF <- data.frame(v1 = c(1,3,5,7,8,3,5,NA,4,5,7,9),
                     v2 = c(11,33,55,77,88,33,55,NA,44,55,77,99) )
by1 <- c("red", "blue", 1, 2, NA, "big", 1, 2, "red", 1, NA, 12)
by2 <- c("wet", "dry", 99, 95, NA, "damp", 95, 99, "red", 99, NA, NA)
aggregate(x = testDF, by = list(by1, by2), FUN = "mean")

aggregate(weight ~ feed, data = chickwts, mean)


#### CH 14.2 : Grouping Operation : Table Operation ####
tabulate( bin=sample(1:99 , 20 ,replace=T)  , nbins = 10)  #  check times of occurrence from 1 to 10
tabulate( c("肉","蛋","米","蛋","蛋","肉","米","蛋","肉"))  #  wrong ! it must be applied to factor input
tabulate( factor( c("肉","蛋","米","蛋","蛋","肉","米","蛋","肉")) )
margin.table(new.table , 2)

#### ___________________________________________________________ ####
#### CH 14.3 : Handle with Chracter Data ####

#### CH 14.3 : Handle with Chracter Data : Regular Expression. ####
'https://zh.wikipedia.org/wiki/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F'


#### CH 14.3 : Handle with Chracter Data : Bulit-in func. ####

#paste
paste(1:5 , letters[1:5] , sep='-' , collapse = '*')

#sprintf
sprintf("%5.1f", pi)
sprintf("%02d", 1)
sprintf("%10f", 1/3)
sprintf("%-10f", pi)
sprintf("%+f", pi)
sprintf("%1$o", c(15,17,19))
# as.octmode(c(15,17,19)) show first argument after the transformation to octal number

#---Lab Practice---#
# use paste and sprintf to create character vector of 2017-01~09-01

# substr / substring
substr('abcdefg' , 1 , 3)
substring('abcdefg' , 1 , 3)

substr('abcdefg' , 1)  #  need end value
substring('abcdefg' , 1) #  default end value will lead to all string

substr(rep('abcdef',4) , 1:4 , 4:5)  #  special way to extract string

# grep / grepl
grep("[a-z]", '12548a')
grepl("[a-z]", '12548a')  #  grepl returns T/F logical instead real value
grep('^b.*7$' , c('b125' , 'b47' , 'a578b7' , 'bc9930  7') , value=T)  #  return real value with T/F logical value = TRUE


# sub / gsub
str <- 'Now is the time   '
sub(' +$', "", str)
gsub(" +$", "", str)
gsub("\\s+$", "", str)

sub('A' , '123' , "Avew ppqrA")  #  sub only replace first encountered matched item
gsub('A' , '123' , "Avew ppqrA")

# strsplit
strsplit('2019-07-12', split = '-')
strsplit('a  b c     d    e', split = '\\s+')[[1]]  #  split with at least one space
strsplit('a  b c     d    e', split = ' +')


#---Lab Practice---#
string <- " Hi buddy  what's     up   Bro   "
# gsub( '^\\s+|\\s+$' , '' , gsub( '\\s+', ' ' , string))
# trimws( gsub( '\\s+', ' ' , string) )

library(stringr)
str_extract_all('ok AAA57 the apple goes away' , '[a-zA-Z]{3}[0-9]{2}')[[1]]

#### ___________________________________________________________ ####
#### CH 14.4 : Useful Packages ####

#### CH 14.4 : Useful Packages : dplyr ####

require(tidyverse)  #  can see lots of conflict func. names
library(dplyr)

# filter
mtcars %>% filter(mpg >= 25 , qsec > 19 )

# mutate
mtcars %>% mutate(Test = vs + am)

# arrange
mtcars %>% arrange(-mpg)

# select
mtcars %>% select(-c(mpg , cyl , wt ))  #  negative list
mtcars %>% select(mpg , cyl , wt )  #  positive list
mtcars %>% select(cyl , everything())  #  smart list
mtcars %>% select(drat ,everything())  # change col order
iris %>% select(starts_with("Petal") )  #  declare start col to end_with(...) end col can be empty

# group_by + summarise
mtcars %>% group_by(vs , gear) %>% summarise(Counts = n() , Grades = sum(vs+gear))  # Noted that it will return tibble class data

# rowise operation

#載入自訂資料dplyr_rowwise_example.csv先做前處理
d <- read_csv('D:/PeterWang/ML_Course/Examples/Data/dplyr_rowwise_example.csv')
head(d)

gsub('\\.$' , '' , d$Period)  # replace . symbol

n <- melt(d , id.vars = c('Period','Meat'))
head(n)

nn <- dcast(n , Meat ~ variable+Period , sum )
nn[1:3,1:5]

#擷取近1年欄位並替換col名稱，方便後續運算
idx.col.01 <- grep(colnames(nn) , pattern = '^Trouble_Count') %>% tail(.,12)
colnames(nn)[idx.col.01] <- letters[1:12]
nn <- nn[,c(1 , idx.col.01)]
head(nn)

#  接著運算近一年內平均每月出現多少件有問題的貨品
nn  %>% rowwise() %>% dplyr::mutate(Year.Trouble.Avg = mean(c(a,b,c,d,e,f,g,h,i,j,k,l))) -> nn  #(試試看不加dplyr::)
head(nn$Year.Trouble.Avg)

nn %>% mutate(Year.Trouble.Avg2 = rowMeans(.[,2:13]) )  #  calculate rowmeans directly

#### CH 14.4 : Useful Packages : tidyr ####

library(readr)
# 讀取範例檔案
tmp.df <- read_csv(file.choose())



# 方法1 (使用內件函數reshape + reshape2套件下的melt函數) #

library(reshape2)
# reshape格式非常複雜，很難第一時間看懂，主要用來做長寬轉換
# 第一個引數放入原始資料，吃data.frame型別，如果不是d.f.記得轉換 (read_csv load近來的資料會是tibble型別)
# 第二個引數direction : 指定現在的格是要轉成長型資料或是寬型資料
# 第三個引數varying : 放入需要被判斷的欄位名稱
# 第四個引數timevar : 放入拆解後的欄位名稱
# 第五個引數times : 放入主要被判斷的格式，以這個例子來說就是female和male
# 第六個引數v.names : 放入次要被判斷的格式，以這個例子來說就是Less20~60
# 第七個引數idvar : 放入每筆觀察值的id (可唯一決定每一筆觀察值的key欄位，比方說身分證字號、產品標籤序號...等等)
reshape(as.data.frame(tmp.df),
        direction='long',
        varying=c('female.Less20','female.Less40','female.Less60','male.Less20','male.Less40','male.Less60'),
        timevar='Sex',
        times=c('female', 'male'),
        v.names=c('Less20','Less40','Less60'),
        idvar='Observation') -> tmp.df2


# 由於reshape的功能限制，沒辦法一次將多個性別和多個Less拆開後各自訂成一個欄位，所以我們需要用melt把剩下的欄位堆起來!
melt(tmp.df2 , id.vars = c('Observation','Sex') , value.name = "Value")




# 方法2 (使用tidyr達成) #

# 這個套件專門用來對付難搞資料，屬於高階資料處理套件
library(tidyr)

# gather函數類似reshape2套件的 melt，把變數堆疊起來
# 第一個引數放入原始資料
# 第二個引數放入類別變數堆疊後的columns name
# 第三個引數放入數字觀察值的columns name
# 第四個引數放入每筆觀察值的id (可唯一決定每一筆觀察值的key欄位，比方說身分證字號、產品標籤序號...等等)
tmp.df_new <- gather(tmp.df , variable , count  ,-Observation) #沒加負號的話，該欄位也會被堆疊進去
head(tmp.df_new)

# seperate 會自動偵測格式，可以把指定column拆成不同形式
# 第一個引數放入需要被拆解的資料
# 第二個引數放入需要被拆解的欄位
# 第三個引數放入被拆解出來的欄位要用什麼名稱 (順序將依照原始被拆解欄位的格式進行，以這個例子來說就是性別+class)
separate(tmp.df_new , variable , c("sex","class")) -> tmp.df2


# 使用dplyr搭配tidyr直接一行完成
tmp.df %>% gather(. , type , value  ,-Observation) %>% separate(. , type , c("sex","class"))



# spread函數可以將具備不同level的變數完整拓展開
# 第一個引數放入需要被操作的資料
# 第二個引數放入需要被拓展的column
# 第三個引數放入計算值
spread(tmp.df2 , class , count)
