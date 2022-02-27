######################################
####   CH05 - Matrix and Array    ####
######################################

#### CH 05.1 : Definition ####

#### CH 05.1 : Definition : Matrix Class ####

# construct matrix
y <- matrix(seq(1:6) , nrow=2 , byrow=TRUE);  y ; class(y)

# vector transpose
x <- t( c('A'=1,2,3,4)) ;  x ; class(x)

# rbind func.
x <- rbind(  c(95,96,97) , c(-10,-20,-30) ) ; x

# cbind func.
x <- cbind(  c(95,96,97) , c(-10,-20,-30) ) ; x


#### CH 05.1 : Definition : Array Class ####

# construct array
y <- array(1:15 , dim=c(3,5)) ; y

# rbind and cbind
x <- rbind(  c(95,96,97) , c(-10,-20,-30) ); x


#### ___________________________________________________________ ####
#### CH 05.2 : Object Attributes ####

#### CH 05.2 : Object Attributes : Properties of Matrix and Array ####
x <- matrix( c(1,2,3,”A”,5,6) , nrow=2 , byrow=TRUE);  x ; class(x)
x <- array( c(1,2,3,"A",5,6)) ; x ; class(x)

# matrix is 2-dimension array
y <- array(1:15 , dim=c(3,5)) ; is.matrix(y)


#### CH 05.2 : Object Attributes : Matrix Addition and Subtraction ####

# addition / subtraction
m1 <- matrix(10:21 , nrow=3)
m2 <- matrix( 1:6 , nrow=3 )
m1 + m2

m3 <- matrix(90:101 , nrow=3)
m1 + m3

# Addition on vector and matrix
v1 <- c(0 , 9999)
m1 + v1

#### CH 05.2 : Object Attributes : Matrix Multiplication ####

# Multiplication on matrix and vector
v1 <- c(1,0,1) ;  m1 <- matrix(1:6 , nrow=3) ; v1 %*% m1

# Multiplication on matrice
m1 <- matrix(1:6 , nrow=3)
m2 <- matrix(c(-10,5,7,15,11,20,0,-4,-8) , nrow=3 )
m1 %*% m2 # error!  why?
m2 %*% m1


#### CH 05.2 : Object Attributes : Matrix Related Func. ####

# determinant / inverse matrix / eigenvalues and eigenvectors
m2 <- matrix(seq(1,18,by=2) , nrow=3 )
det(m2) ; solve(m2) ; eigen(m2)

y <- matrix(1:10 , nrow= 2 , byrow=TRUE) ; y ; dim(y) ; diag(y)


#### ___________________________________________________________ ####
#### CH 05.3 : High Dimension Array ####

#### CH 05.3 : High Dimension Array : 3-dimension Array ####

# construct 3-dim array
z <- array(1: 24 , dim=c(2,3,4)) ; z

# change dimension names
dimnames(z)[[3]] <- c('AAA','BBB','CCC','DDD') ; z

# Appendix
t <- aperm(z , perm = c(2,3,1)) ; t  #  permutation on array dimension : original (2,3,4) to (2,3,1)

