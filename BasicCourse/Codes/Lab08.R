######################################
####      CH08 - Data Frame       ####
######################################

#### CH 08.1 : Definition ####

#### CH 08.1 : Definition : Data Frame Class ####

x <- data.frame(Name='Ted', Sex='Male' , Blood_Type = 'AB') ; x ; class(x)  #  '' symbol for colnames is not neccessary
edit( x <- data.frame(Name='Ted', Sex='Male' , Blood_Type = 'AB') )  #  custom edit data

# define columns
x <- data.frame(id= c(1,57,22) , Name= c('Ted','Johnny','Kelly') , stringsAsFactors = T)
str(x)

# custom rownames
x1 <- data.frame(id= c(1,57,22) , Name= c('Ted','Johnny','Kelly') , row.names = c("A" , "B" , "C"))
x1

# set rownames by 1st column
x2 <- data.frame(id= c(1,57,22) , Name= c('Ted','Johnny','Kelly') , row.names = 1)
x2



#### ___________________________________________________________ ####
#### CH 08.2 : Object Attributes ####

#### CH 08.2 : Object Attributes : Structure ####
as.list(mtcars[1:3,1:3])
as.data.frame(as.list(mtcars[1:3,1:3]))
is.list(mtcars[1:3,1:3])

head(mtcars , 6)
head(mtcars , 999)
head(mtcars , -1)
head(mtcars , -5)


#### CH 08.2 : Object Attributes : Edit Data ####

# edit elements
edit( y <- data.frame() )
y # null object

# edit colnames
y <- edit( data.frame() )
colnames(y) <-  c("AAA", 'BBB' , 'CCC') ; y





