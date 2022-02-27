######################################
####        CH04 - Vector         ####
######################################

#### CH 04.1 : Definition ####

#### CH 04.1 : Definition : Vector Class ####

x <- c(1,2,3,4,5) ; x                                 #  simple vector
seq(1:10) ; is.vector(seq(1:10))


#### ___________________________________________________________ ####
#### CH 04.2 : Object Attributes ####

#### CH 04.2 : Object Attributes : Properties ####

y <- c(4 , 'Hyperlink') ; y ; class(y)                #  character vector
z <- c(1,2,3) ; zz <- c(z,c(5,6,7)) ; zz ; class(zz)  #  combine vector
t <- c('A'=5,'B'=10,'C'='Nest') ;t; class(t)          #  named vector
names(t)

#### CH 04.2 : Object Attributes : Opertaion ####

# Addition
c(1,2,3) + 1

# Subtraction
c(5, 8   ,10) -7

# Multiplication
c(7,99) * c(2,10)

# Division
c(11,55,-87) / 2.66

# Occurrs error !
c(15,14,13) + c(1,1)


#### ___________________________________________________________ ####
#### CH 04.3 : Another type of vector ####

#### CH 04.3 : Another type of vector : Logical ####

# construct
c(TRUE,F,FALSE)

# by criterion
c(-1,0,1,2,3,) >= 0
is.vector(is.character("AAA") )
LETTERS[1:5] != 'A'


#### CH 04.3 : Another type of vector : Character ####

# construct
c("KFC" , "McDonald" , "MosBurger")

# by func.
character(3)
colnames(iris)
