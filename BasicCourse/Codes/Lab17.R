######################################
####    CH17 - RDB Connection     ####
######################################

#### CH 17.1 : ODBC ####

#### CH 17.1 : ODBC : Introduction ####
# see text book

#### CH 17.1 : ODBC : Download and Setup ####
# see text book

#### CH 17.1 : ODBC : Establish Connection ####
# see text book

#### CH 17.1 : ODBC : Query Data ####
library("RODBC")
library(dplyr)

# start connection
channel <- odbcConnect("R_SQL2", uid="player01", pwd="123000456")

# query data
df <- sqlQuery(channel, "
with t0 as (
select a.faq_id , YEAR(date) Yr , a.activity , b.language_id from dbo.Support_T_FAQ_Log a
left join dbo.Support_T_FAQ_Master b
on a.faq_id = b.id
where a.ip_type = 'External' and useful = 0
) select Yr , language_id , activity ,count(activity) Cnt from t0
group by Yr , language_id , activity
having activity='View' or activity='Download';")
head(df)

# close connection
odbcClose(channel)


# dev.off can reset parameters
