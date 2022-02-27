######################################
####         CH07 - List          ####
######################################

#### CH 07.1 : Definition ####

#### CH 07.1 : Definition : List Class ####
attach(mtcars)
tmp <- lm(mpg~disp+hp+drat)
class(tmp)  #  data type in R can be custom named
tmp$residuals
mode(tmp)   #  true data type will be displayed via using mode(...)



#### ___________________________________________________________ ####
#### CH 07.2 : Object Attributes ####

#### CH 07.2 : Object Attributes : Structure ####

# construct an example
x <- list("Name"=quote(1+2) , "Salary"=c(22000,55000,99999,0,155) , "DF"=data.frame("A"=1:2 , "B"=2:3))
x
class(x)
attributes(x)

# check every elements' class
class(quote(1+2)) ; class(c(22000,55000,99999,0,155)) ; class(data.frame("A"=1:2 , "B"=2:3))

# faster way to get it done
lapply(x,class)

