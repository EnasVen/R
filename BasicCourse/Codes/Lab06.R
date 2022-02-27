######################################
####        CH06 - Factor         ####
######################################

#### CH 06.1 : Definition ####

#### CH 06.1 : Definition : Factor Class ####

# Levels
x <- factor(c('高','中','低') , levels = c('低','中','高') ) ; x

# Labels
x <- factor(c(1,5,7,11) , labels = c('B','C','T','N')) ; x



#### ___________________________________________________________ ####
#### CH 06.2 : Object Attributes ####

#### CH 06.2 : Object Attributes : Property ####

# can't be used in calculation
factor(1:6) + factor(1:3)

# can be transformed to numerical order by as.numeric(...)
x <- factor(c(1,5,7,11) )
as.numeric(x)

x <- factor(c(1,5,7,11) , levels = c(7,5,1,11))
as.numeric(x)

# can be transformed to vector by as.vector(...)
x <- factor(c(1,5,7,11) )
as.vector(x)

# same result comes from levels(...)
x <- factor(c('a','b','c'))
levels(x)



#### CH 06.2 : Object Attributes : Ordered and Reorder ####

# ordered
ordered(factor(c(1,2,3,4)),levels=c(4,2,1,3))
ordered(factor(c('高','中','低') , levels = c('低','中','高') ))

# Reorder
library(ggplot2)  #包含mpg資料集
library(dplyr)

# before (notice that x axis has alphabetical order)
mpg %>%
  ggplot( aes(x=class, y=hwy, fill=class)) +
  geom_violin() +
  xlab("class") +
  theme(legend.position="none") +
  xlab("")

# after
mpg$class <- with(mpg, reorder(class, hwy, median))
mpg %>%
  ggplot( aes(x=class, y=hwy, fill=class)) +
  geom_violin() +
  xlab("class") +
  theme(legend.position="none") +
  xlab("")




