######################################
#### CH02 - Objs & Basic Operation####
######################################

#### CH 02.1 : Objects and Nomination ####

#### CH 02.1 : Objects and Nomination : Basic Syntax ####

# Basic Codes
rm(list=ls())
help.start()   # main menu to beginners
help('mean')   # find func. deatil way to use
?mean          # same way to help

apropos('plot') # find inherit func. having name 'plot'
find('sd', simple.words = TRUE)   # find which package has certain func.
find('sd', simple.words = FALSE)  # ambigious query
ls(pattern = '^is' , baseenv())  # list out func.s with is.xxx

# Naming Objects
a <- 3 ; a
a = 7 ; a
var001 -> 99 ; var001
a <- b <- 55 -> c ; a
a <- 55 <- 55 -> 0 ; a  #  wrong way ! cant assign value to numbers
rm(a) ; a   #  remove objects


#### CH 02.1 : Objects and Nomination : Advanced Syntax ####

# difference between = and <-
sqrt(x = c(1,4,8,16)) ; x
sqrt(x <- c(1,4,8,16)) ; x


# <<-
x <- c(1,4,8,16)
tmp = function(x){
  print(x)
  x <<- 5
}
tmp(x) ; x


# example
y <- 1
f1 <- function(y){
  y <- y +99
  return(TRUE)
}
f1(y) ; y

y <- 1
f2 <- function(y){
  y <<- y +99
  return(TRUE)
}
f2(y) ; y


#### CH 02.1 : Objects and Nomination : Data Type ####
# class
x <- factor(1:5)
class(x)

# str
x <- factor(1:5)
str(x)

# mode
x <- factor(1:5)
mode(x)


#### ___________________________________________________________ ####
#### CH 02.2 : Basic Math Calculation ####

#### CH 02.2 : Basic Math Calculation : Operation ####

# simple operation
5 + 1
10-3
9*5
10*3
7%/%3
7%%3
(9+1)/(2+0.5)
#{2+[5-(3+1)]}  #  wrong way !  Always use small brackets (...) to compute !


# vector operation
c(1,2,3) + 1
c(5, 8   ,10) -7
c(7,99) * c(2,10)
c(11,55,-87) / 2.66
#c(15,14,13) + c(1,1)  #  wrong way ! Vector length must be the same !


# matrix operation
matrix(-2:9,nrow=3) + c(1,999)
matrix(-2:9,nrow=3)-matrix(1:12,nrow=3)
matrix(-2:9,nrow=3) %*% matrix(1:4)


#### ___________________________________________________________ ####
#### CH 02.3 : Inf/NaN/NA  ####

#### CH 02.3 : Inf/NaN/NA : Special Symbols ####

# Infinite
Inf + 8
0+(-Inf)
Inf / Inf

# NA
NA / 0
NA + NaN

# NaN
0 / 0
sqrt(-87)
