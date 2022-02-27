######################################
####    CH12 - Object Indexing    ####
######################################

#### CH 12.1 : Indexing Specification ####

#### CH 12.1 : Indexing Specification : General Rules ####

# with name
x <- c("TestName"='Peter' , "Weight"=50)
x[1]
x["TestName"]  # index can also be execute by direct colnames

# without name
x[[2]]
x[['Weight']]

# $ indexing
# Using 'mtcars' data frame
mtcars$mpg

# Using the example introduced in 'list' chapter
x <- list("Name"=quote(1+2) ,
            "Salary"=c(22000,55000,99999,0,155) ,
            "DF"=data.frame("A"=1:2 , "B"=2:3))
x$DF ; x$Salary[2:3]


#### ___________________________________________________________ ####
#### CH 12.2 : Indexing Methods for Different Type Objects ####

#### CH 12.2 : Indexing Methods for Different Type Objects : Vector,Factor,Array & Matrix ####

# using numbers to index
#使用先前介紹向量的例子
a <- c(4,99,0,-77)
a[2]

#使用先前介紹陣列的例子
z <- array(1: 24 , dim=c(2,3,4))
z[1,2:3,1]

#使用先前介紹因子的例子
x <- factor(c(1,5,7,11,5) , labels = c('B','C','T','N'))
x[5]

#使用先前介紹矩陣的例子
y <- matrix(seq(1:6))
y[2,1]

# using name to index
#使用先前介紹向量的例子
t <- c(A=5,B=10,C='Nest')
t['C']

#使用先前介紹因子的例子
tt <- as.factor(t)
tt['A']

#使用先前介紹陣列的例子
dimnames(z)[[3]] <- LETTERS[1:4]
z[1,2,'D']

#使用先前介紹矩陣的例子
colnames(y) <- 'Test'
y[c(1,3,5,6),'Test']

#### CH 12.2 : Indexing Methods for Different Type Objects : List ####

# [i] & ['name']
x <- list("Name"=quote(1+2) ,
          "Salary"=c(22000,55000,99999,0,155) ,
          "DF"=data.frame("A"=1:2 , "B"=2:3))

x[1]
x['DF']

# [[i]] & [['name']]
x[[1]]
x[['DF']]
x$Name

# Notice the class of returned objects
x[2] ; class(x[2])
x[[2]] ; class(x[[2]])  # [[...]] in list will return vector

# Another example
y <- list(quote(1+2) , c(22000,55000,99999,0,155) , data.frame("A"=1:2 , "B"=2:3))
y[1]
y[[1]]
y$1  #  this will return error cuz list y has no element names

#### CH 12.2 : Indexing Methods for Different Type Objects : Data Frame ####

#使用mtcars資料集做索引練習
y <- head(mtcars)
y[2]
y['mpg']
y[[2]]
y[['mpg']]
y$gear[1:5]
y[[3,4]]


#### ___________________________________________________________ ####
#### CH 12.3 : Ancillary Indexing ####

#### CH 12.3 : Ancillary Indexing : Logical Indexing ####

# using which to index data
which( mtcars$wt < 1.52 , arr.ind=T)
which( mtcars==21 , arr.ind = T)

# compare objects
match(seq(1,7,by=1.3),  c(1,2.3) )  # find elements of second augment that appears in first augment
match(seq(1,7,by=1),  c(3,4,99) )
