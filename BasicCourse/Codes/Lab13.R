######################################
####       CH13 - Data I/O        ####
######################################

#### CH 13.1 : Basic Data I/O ####

#### CH 13.1 : Basic Data I/O : Univariate Data Imput ####

# simple input :　scan
tmp <- scan()  #   use scan to input manually
tmp <- scan('D:/PeterWang/ML_Course/Examples/Data/test.txt')   #  input from local txt file
tmp <- scan('D:/PeterWang/ML_Course/Examples/Data/test02.txt' , sep= ',')

#### CH 13.1 : Basic Data I/O : Univariate Data Output ####

# simple input : write
write(1:7 , '' , ncol = 10)
write(1:7 , 'D:/PeterWang/write.txt' , ncol = 7)
write(matrix(1:15,ncol=5) , '')
write( t(matrix(1:15,ncol=5)) , "" , ncol =5)

#### CH 13.1 : Basic Data I/O : Multivariate Data Imput ####

# simple input : read.table / read.csv
read.table(file = 'D:/PeterWang/ML_Course/Examples/Data/test01.txt' , header = T , stringsAsFactors = F , na.strings = '-')
read.csv(file = "D:/PeterWang/ML_Course/Examples/Data/test.csv" , header = T , sep=",")


#### CH 13.1 : Basic Data I/O : Multivariate Data Output ####

# simple output : write.table / write.csv
x <- data.frame(Name='Ted', 'Sex'='Male' , Blood_Type = 'AB')
write.table(x,"D:/PeterWang/ML_Course/Examples/Data/test_write.table.csv",row.names = T , col.names = T , sep = ',' , quote = T)
write.table(x,"D:/PeterWang/ML_Course/Examples/Data/test_write.table.csv",col.names = T , sep = ',' , quote = T , append = T)  # remove rownames to adjust data


#### ___________________________________________________________ ####
#### CH 13.2 : Other Format Data I/O ####

#### CH 13.2 : Other Format Data I/O : Construct JSON Data ####

# use below data to construct test json file (do not run these code !!)
# {
#   "ID":["No.121","No.122","No.123","No.124","No.125","No.126","No.127","No.128" ],
#   "ATK":["400","3050","3710","3560","2850","2040","850","1750" ],
#   "DEF":["1570","232","105","145","350","635","1080","4000" ],
#   "SalesDate":[ "1/5/2017","12/13/2007","1/25/2018","4/28/2018","7/5/2018","9/21/2019", "10/30/2019","6/17/2020"],
#   "Type":[ "Wind","Void","Fire","Fire","Wind","Wind","Water","Light"]
# }


#### CH 13.2 : Other Format Data I/O : Imput JSON Data ####

library("rjson")
result <- fromJSON(txt = "D:/PeterWang/ML_Course/Examples/Data/input.json")
print(result)
as.data.frame(result)  #  convert list to d.f.

# import json file from website
library(jsonlite)
data<- jsonlite::fromJSON("http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=f4a75ba9-7721-4363-884d-c3820b0b917c")

# convert d.f. to json
jsonlite::toJSON(iris, pretty=TRUE)   #  pretty means if the form is human readable

#### CH 13.2 : Other Format Data I/O : Construct XML Data ####

# use below data to construct test XML file (do not run these code !!)
# <FILES>
#   <CHARACTER>
#   <ID>a123456</ID>
#   <NAME>ok9527</NAME>
#   <GEMS>105005</GEMS> 	<ACCOUNTSTART>1/1/2010</ACCOUNTSTART> 	<GUILD>Top1</GUILD>
#   </CHARACTER>
#   <CHARACTER>
#   <ID>b789003</ID>
#   <NAME>retard9527</NAME>
#   <GEMS>10</GEMS>
#   <ACCOUNTSTART>7/30/2010</ACCOUNTSTART>
#   <GUILD>Bot1</GUILD>
#   </CHARACTER>
# </FILES>


#### CH 13.2 : Other Format Data I/O : Imput XML Data ####

library("XML")
result <- xmlParse(file = "D:/PeterWang/ML_Course/Examples/Data/input.xml")
print(result)  # Print the result.

xmlParse(file = "D:/PeterWang/ML_Course/Examples/Data/input.xml")

#### ___________________________________________________________ ####
#### CH 13.3 : Advanced Data I/O ####

#### CH 13.3 : Advanced Data I/O : Object Preservation ####

# save/load objects by rda RData file
save(x,file = 'D:/PeterWang/ML_Course/Examples/Data/test_rda.rda')
rm(x) ; x   #  remove objects from current environment
load('D:/PeterWang/ML_Course/Examples/Data/test_rda.rda') ; x  #  load object x from local file

save.image(file="D:/PeterWang/ML_Course/Examples/Data/all.RData")  # save all
save(x, y, z , file="1.RData") # save part of variables
rm(list=ls())
load('D:/PeterWang/ML_Course/Examples/Data/all.RData')

#### CH 13.3 : Advanced Data I/O : Multiple File I/O ####

# High Level input output
list.files('D:/PeterWang/Data/' , pattern = '.csv' )
do.call("rbind",lapply(paste("D:/PeterWang/Data",files,sep="/"),read_csv))

#### CH 13.3 : Advanced Data I/O : External Resource Import ####

# Source from script file
source('D:/PeterWang/ML_Course/Examples/Source.r')
test.func("Baby")
test.func(1:100)

#### ___________________________________________________________ ####
#### CH 13.4 : Useful Packages ####

#### CH 13.4 : Useful Packages : readr ####

# useful package : readr
library(readr)
read.csv("D:/PeterWang/ML_Course/Examples/Data/test01.csv")  #  error occurrs cuz # of cols are not equal
read_csv("D:/PeterWang/ML_Course/Examples/Data/test01.csv")  #  readr can swiftly solve this issue
