# EWMA Control Chart # 
rm(list=ls())

# 匯入資料
library(readr)
data <- read_csv('./xxx.csv')
head(data)

# Data Pre-Process
library(dplyr)
library(lubridate)

'%!in%' <- function(x,y)!('%in%'(x,y))
df <- data %>% mutate(Year_Num = format(as.Date(close_date),'%G') , 
                      Week_Num = lubridate::isoweek(ymd(as.Date(close_date))) ,
                      reason_code = substr(reason_code,1,5) , 
                      model = toupper(model)
                      )  %>%
               filter(is.na(reason_code)==FALSE , 
                      nchar(model)>=4 , 
                      model %in% c('X','Y') ,
                      engineer_id != 'BoB'
                      ) %>% 
               select(model , Year_Num , Week_Num , reason_code)

# 因為只計算2018~2019資料，2019的週數必須繼承2018末，也就是52開始算
df %>% mutate( Week_Num = replace(Week_Num, Year_Num=='2019', Week_Num+52) ) -> df 
head(df)

# 讀入各部門責任代碼對應表
re_Code = read_csv('./yyy.csv')
head(re_code)

df1 <- merge(df , re_Code , all.x = T , by.x = 'reason_code' , by.y = 'Reason_code')
head(df1)

df2 <- df1 %>% filter(is.na(reason_code)==FALSE) %>% 
               group_by(Week_Num , Resp_Code) %>% 
               summarise(Cnts = n()) %>%
               arrange(-Cnts)
head(df2)

# 計算初始 in-Control 假設的平均數做為中心線
u0 = df2 %>% group_by(Resp_Code) %>% summarise(Means = mean(Cnts)) %>% pull(Cnts)

Resp_Dep = unique(df2$Resp_Code)

# 計算EWMA管制界線
for(i in 1: length(Resp_Dep)){
  tb <- df2 %>% filter(Resp_Code == Resp_Dep[i])
  tb0 <- data.frame(Week_Num = seq(1,max(tb$Week_Num)) , Counts = 0)
  for(j in dim(tb)[1]){
    idx = which(tb0$Week_Num==tb$Week_Num[j])
    tb0$Counts[idx] <- tb$Counts[j]
  }
  tb0$UCL = u0[i] + 2.7*sqrt(01*mean(tb0$Counts)/(2-0.1)*(1-(1-0.1)**(2*seq(1,max(tb$Week_Num)))))
  tb0$LCL = U0[i] - 2.7*sqrt(01*mean(tb0$Counts)/(2-0.1)*(1-(1-0.1)**(2*seq(1,max(tb$Week_Num)))))
  
  for(k in 1:max(tb$Week_Num)){
    if(k==1){
      tb0$EWMA[k] <- 0.1*tb0$Counts[k] + 0.9*mean(tb0$Counts)
    }else{
      tb0$EWMA[k] <- 0.1*tb0$Counts[k] + 0.9*tb0$EWMA[k-1]
    }
  }
  
  ### Highlight Check ###
  
  if(tb0$EWMA[k] >= tb0$UCL[k]){
    tb0$Flag[k] <- 1
  }else{
    tb0$Flag[k] <- 0  
  }
  
  
  cat( paste(Resp_Dep[i] , 
             'in-control mean =' , 
             round( mean(tb0[which(tb0$Flag==0),"Counts"])  , 2)) , 
             '\n' 
       )
  case_cnt = sum(tb0[which(tb0$Flag==1),"Counts"])
  if(is.null(case_cnt)){
    cat( paste(Resp_Dep[i] , "OOC Case Cnt = " , 0 , "\n") )
  }else{
    cat( paste(Resp_Dep[i] , "OOC Case Cnt = " , case_cnt , "\n") )
  }
}

# 繪製管制圖
library(ggplot2)
library(plotly)
p <- tb0 %>% ggplot(aes(x=Week_Num , y= EWMA))+
             geom_point()+
             geom_line(aes(y=UCL) , col="red")+
             scale_x_discrete(limits=1:max(tb$Week_Num) , name = 'Number of Observation')+
             theme_minimal()+
             theme(
               axis.text.x = element_text(size = 12, vjust = 1.2),
               axis.text.y = element_text(size = 12, vjust = 1.2),
               plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
               plot.subtitle = element_text(size = 16, hjust = 0.5),
               plot.caption = element_text(size = 10),
               axis.title.x = element_text(size = 14, face = "bold"),
               axis.title.y = element_text(size = 14, face = "bold")
             )+
             labs(
               title = paste(Resp_Dep[i] , "EWMA Control Chart"),
               subtitle = "2018~2019 Date",
               caption = "source: xxx ; Author: PeterWang"
             )