######################################
####      CH15 - Flow Control     ####
######################################

#### CH 15.1 : Logical Judgment ####

#### CH 15.1 : Logical Judgment : Condition and Expression ####

# Difference between & and &&
v1 <- c(1,2,3)
v2 <- c(-2,-5,8)

v1>0 & v2<0
v1>0 && v2<0

# Given a and b , try to compute if a lies in (0.3,b] and [100,999)
a <- 10
b <- 7
#(a < b && a > 0.3) || (a >= 100 && a < 999)

#### CH 15.1 : Logical Judgment : Conditional Func. ####

# ifelse
x <- c(6:-4)
sqrt(ifelse(x >= 0, x, NA))  # no warning

t <- -999
if(t>0){
  cat('Apple')
}else if(t==0){
  cat('Melon')
}else{
  cat('Orange')
}

# switch
switch(1,sum(1:10), cat("Result2"), rnorm(1))   #  default order 1,2,3...

switch('1',sum(1:10), cat("Result2"), rnorm(1))  #  invalid input will lead to error

switch("Test03" , "Test01"=cat("01") , "Test02"=999 , "Test03"=seq(1:7))  #  specify value input

switch('Test99' , 'Test01'=cat('01') , 'Test02'=999 , 'Test03'=seq(1:7) , 500)

#### CH 15.1 : Logical Judgment : Common Errors ####
if (5+3 == 8) print(1)
else print(0)

if (-5 <= 0){ print(1)}
else {print(0)}

{if (-5 <= 0){ print(1)}
  else {print(0)}
}



#### ___________________________________________________________ ####
#### CH 15.2 : Loop and Custom Func. ####

#### CH 15.2 : Loop and Custom Func. : Loop Structure ####

# For Loop
for(i in 1:10){
  cat('this is ' , i , ' th iteration !' , '\n')
}

# While Loop
i=0
while(i<=9){
  i=i+1
  cat('this is ' , i , ' th iteration !' , '\n')
}

# Repeat Loop
i=0
repeat{
  i=i+1
  cat('this is ' , i , ' th iteration !' , '\n')
  if(i==10) break
}


# break & next
for(i in 1:3){
  cat('Current loop i ',i , '\n')
  for(j in 4:6){
    if(j==5) break
    cat(j , '\n')
  }
}

for(i in 1:3){
  cat('Current loop i ',i , '\n')
  for(j in 4:6){
    if(j==5) next
    cat(j , '\n')
  }
}


#### CH 15.2 : Loop and Custom Func. : Custom Function ####

# customize your function
test.func <- function(x) {
  if(x>=5){
    return(10)
  }else{
    return(20)
  }
}

# ... symbol in function

N01 <- function( y , ...){ return(prod(y, ...))}
N01(2,4,6,8)

N02 <- function( y , ...){
   return(quantile(y , ... ))
}
N02(y=c(1:100) , probs = seq(0,1,0.25) , na.rm = TRUE , names = FALSE , type = 7)

#### ___________________________________________________________ ####
#### CH 15.3 : Efficiency Administarion ####

#### CH 15.3 : Efficiency Administarion : Compiling speed ####
N <- 10000
x1 <- runif(N)
x2 <- runif(N)

d <- as.data.frame(cbind(x1, x2))

system.time(
  for (loop in c(1:length(d[, 1]))) {
    d$mean2[loop] <- mean(c(d[loop, 1], d[loop, 2]))
})

system.time(d$mean1 <- apply(d, 1, mean))

system.time(d$mean3 <- rowMeans(d[, c(1, 2)]))

#### CH 15.3 : Efficiency Administarion : Memory Control ####
memory.profile()
gc(verbose = T)

if(.Platform$OS.type == "windows") withAutoprint({
  memory.size()
  memory.size(max=TRUE)
  memory.limit()
})

memory.limit(size=xxx)

# file.edit(file.path("~", ".Rprofile"))
# invisible(utils::memory.limit(size = 60000))  # type this in RProfile script! and restart R

#### CH 15.3 : Efficiency Administarion : Preallocate Memory ####
idx <- 50000
v1 <- 100
system.time(for (i in 1:idx) {
  v1 <- c(v1 , rt(1, 10) + rnorm(1, i, 4))
})

v2 <- numeric(idx)
system.time(for (i in 1:idx) {
  v2[i] <- rt(1, 10) + rnorm(1, i, 4)
})
