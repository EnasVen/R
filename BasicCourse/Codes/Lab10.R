######################################
####         CH10 - Time          ####
######################################

#### CH 10.1 : Definition ####

#### CH 10.1 : Definition : Date Class ####
Sys.time()
class(Sys.time())
as.Date(Sys.time())
class(as.Date(Sys.time()))

#### ___________________________________________________________ ####
#### CH 10.2 : Object Attributes ####

#### CH 10.2 : Object Attributes : POSIX ####

# format
format(Sys.time() , format = "%d-%m-%Y")
format(Sys.time() , format = "%d-%m-%Y %H:%M:%S")

# as.POSIXct
as.POSIXct(as.character(Sys.time()), format="%Y-%m-%d %H:%M:%OS")

# as.POSIXlt
as.POSIXlt(Sys.time() , tz='UTC')
x <- as.POSIXlt(as.character(Sys.time()), format="%Y-%m-%d %H:%M:%OS")
x$year ; x$wday ; x$mon
class(x) #  class of x is POSIXt form
mode(x)  #  true class of object x will be displayed


# strptime
strptime("27.08.2019.17:35:30", format = "%d.%m.%Y.%k:%M:%S")

# time calculation
difftime('2018-01-05 17:58:03' , '2017-02-04 02:15:11' , units = "secs")


#### CH 10.2 : Object Attributes : Date ####
as.Date(Sys.time())
as.Date("2020-03-26 17:37:06 UTC")
as.Date(365*20 , origin = '1970-01-01')
as.Date(365 , origin = '2018-01-01')  # from origin to end

#### ___________________________________________________________ ####
#### CH 10.3 : Useful Packages ####

#### CH 10.3 : Useful Packages : lubridate ####

# import package lubridate
if(!'lubridate' %in% installed.packages()){install.packages('lubridate')}else{cat('Already installed ! \n')}
library(lubridate)

# different ways of time class
mdy('07-25-2018')
ydm('2018-25-07')
dmy('07-25-2018')

# auto detect
parse_date_time("I was born in 20180508" , orders = "ymd")

# handle with chinese date format
lubridate::ymd_hm(gsub("上午" , "PM" , "2017-10-04 上午 11:12")) # why not working ?
lubridate::ymd_hm(paste( gsub("上午" , "" , "2017-10-04 上午 23:12"), "PM" , sep=" "))
lubridate::ymd_hm(paste( gsub("下午","", '2017-09-10 下午 06:36') , "PM" , sep=" "))


