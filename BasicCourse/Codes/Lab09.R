######################################
####         CH09 - Table         ####
######################################

#### CH 09.1 : Definition ####

#### CH 09.1 : Definition : Table Class ####
b <- factor(rep(c("A","B","C"), 10))
table(b , exclude = "B")

with(airquality, table(OzHi = Ozone > 80, Month, useNA = "ifany"))
with(airquality, table(OzHi = Ozone > 80, Month, useNA = "no"))
with(airquality, table(OzHi = Ozone > 80, Month, useNA = "always"))

a <- letters[1:3]
table(a, sample(a) ,deparse.level = 1)



#### ___________________________________________________________ ####
#### CH 09.2 : Object Attributes ####

#### CH 09.2 : Object Attributes : Table ####

# Table
x <- sample(1:10 , 100 , rep=TRUE)
table(x)

# factor to table
d <- factor(rep(c("A","B","C"), 10), levels = c("A","B","C","D","E"))
table(d, exclude = "B")

# vector to table
vv <- c("A"=1 , "B"=2 , "A"=3 , "C"=1 , "D"=0 , "E" = 3)
table(vv , names(vv))

v1 <- c("蘋果" , "葡萄" , "李子")
v2 <- c(1,2,3)
table(v1 , v2)

# recoding to build table
idx <- 1+(mtcars$wt > 2.75)
type <- c("A" , "B")
new.class <- type[idx]
vs <- mtcars$vs
new.table <- table(vs,new.class) ; new.table

attributes(new.table)
is.array(new.table)  #  way of indexing array can be applied on table



#### ___________________________________________________________ ####
#### CH 09.3 : Other Func. ####

#### CH 09.3 : Other Func. : xtabs ####

#使用內建UCB入學申請資料集
DF <- as.data.frame(UCBAdmissions)
head(DF)

xtabs(Freq ~ Gender + Admit , DF , subset = (Dept %in% c('A','C') & Freq <= 100) )

# table using recoding vs. xtabs
tmp.df <- data.frame(vs=vs , new.class = new.class)
new.table2 <- xtabs(~ vs + new.class , data = tmp.df)  #  xtabs
new.table2
