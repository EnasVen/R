# parallel processing
rm(list=ls())
library(dplyr)
library(stringr)

# 設定初始牌池
# pool.0 = rep( paste( c('S','H','D','C') , rep(1:13 , each = 4) , sep = "") , 8)
# exp.index = 1
# Total.df = data.frame(Player.1='TBD',Player.2='TBD',Player.3='TBD',
#                       Banker.1='TBD',Banker.2='TBD',Banker.3='TBD',
#                       Player.Points = '999' , Banker.Points = '999', GameResult = 'TBD' ,
#                       CardsLeft = '999' , TurnNum = '999' , DenseEvent = '999' , stringsAsFactors = F)

'%!in%' <- function(x,y)!('%in%'(x,y))
library(foreach)
library(doSNOW)
library(parallel)
cl <- makeCluster(8, type="SOCK") # for 4 cores machine
registerDoSNOW (cl)

#condition <- exp.index < target.turn

# parallelization with vectorization
target.turn = 10000


system.time({
  output <- foreach(i = 1:target.turn  , .packages = c('dplyr' , 'stringr') ) %dopar% {
    
    pool.0 = rep( paste( c('S','H','D','C') , rep(1:13 , each = 4) , sep = "") , 8)
    save.df = data.frame(Player.1='TBD',Player.2='TBD',Player.3='TBD',
                         Banker.1='TBD',Banker.2='TBD',Banker.3='TBD',
                         Player.Points = '999' , Banker.Points = '999', GameResult = 'TBD' ,
                         CardsLeft = '999' , TurnNum = '999' , DenseEvent = '999' , stringsAsFactors = F)
    
    while(length(pool.0) >= 70){
      # initial settings 
      exp.index <- i
      
      Player.Card.vt = Banker.Card.vt = c('TBD','TBD','TBD')
      Player.Points = Banker.Points = '999'
      Game.Result = 'TBD'
      Highlight.index = '0'
      
      # 起始派牌
      sp.0 = sample(1:length(pool.0) , size = 4 , replace = F)
      
      # 更新牌池
      #pool.1 <<- pool.0[-sp.0]
      
      # 分配初始牌卡
      Player.Card.vt[1:2] = c(pool.0[sp.0[1]] , pool.0[sp.0[3]])
      Banker.Card.vt[1:2] = c(pool.0[sp.0[2]] , pool.0[sp.0[4]])
      
      pool.0 <- pool.0[-sp.0]
      
      # 將大於10的卡牌換成0，並計算初始分數 
      Player.Points = sub('.','',Player.Card.vt[1:2]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
      Banker.Points = sub('.','',Banker.Card.vt[1:2]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
      
      # 依照初始牌點決定補牌後續
      if(any(c(Player.Points,Banker.Points) >= 8) ){
        
        # 任一方持有8/9點，則不須補牌，直接輸贏
        Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
        
        # 計算龍七發生時，人工指標(特定牌卡濃度) 
        # 這裡還沒發生，因為沒有到第三張牌
        save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , i , Highlight.index)
        #Total.df = rbind(Total.df , save.vt)
        save.df <- rbind(save.df,save.vt)
        
        
      }else{
        
        
        
        if(Player.Points <6){
          # 閒家優先使用補牌規則
          
          # 不到6點 => 需要補牌
          sp.1 = sample(1:length(pool.0) , size=1 , replace = F)
          # 分派牌卡
          Player.Card.vt[3] = pool.0[sp.1]
          # 更新閒家點數
          Player.Points = sub('.','',Player.Card.vt[1:3]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
          # 更新牌池
          pool.0 <- pool.0[-sp.1]
          ### ### ### ### ###
          
          # 閒家補完換莊家補
          if(Banker.Points < 3){
            # 不到3點 => 需要補牌
            sp.2 = sample(1:length(pool.0) , size=1 , replace = F)
            # 分派牌卡
            Banker.Card.vt[3] = pool.0[sp.2]
            # 更新莊家點數
            Banker.Points = sub('.','',Banker.Card.vt[1:3]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
            # 判定勝負
            Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
            # 計算龍七發生時，人工指標(特定牌卡濃度) 
            Highlight.index = ifelse(Game.Result=='Banker' && Banker.Points==7 ,'1','0')
            # 更新牌池
            pool.0 <- pool.0[-sp.2]
            # 儲存資料
            save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
            #Total.df = rbind(Total.df , save.vt)
            save.df <- rbind(save.df,save.vt)
            
            
          }else if(Banker.Points==3){
            # 根據閒家補牌結果判斷要不要補
            if(sub('.','',last(Player.Card.vt))=='8'){
              # 閒家補到8 => 不需要補牌
              # 判定勝負
              Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
              # 計算龍七發生時，人工指標(特定牌卡濃度) 
              # 無觸發莊家補牌，因此無須計算指標
              # 儲存資料
              save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
              #Total.df = rbind(Total.df , save.vt)
              save.df <- rbind(save.df,save.vt)
              
            }else{
              # 閒家沒有補到8 => 需要補牌
              sp.2 = sample(1:length(pool.0) , size=1 , replace = F)
              # 分派牌卡
              Banker.Card.vt[3] = pool.0[sp.2]
              # 更新莊家點數
              Banker.Points = sub('.','',Banker.Card.vt[1:3]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
              # 判定勝負
              Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
              # 計算龍七發生時，人工指標(特定牌卡濃度) 
              Highlight.index = ifelse(Game.Result=='Banker' && Banker.Points==7 ,'1','0')
              # 更新牌池
              pool.0 <- pool.0[-sp.2]
              # 儲存資料
              save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
              #Total.df = rbind(Total.df , save.vt)
              save.df <- rbind(save.df,save.vt)
              
            }
          }else if(Banker.Points==4){
            # 根據閒家補牌結果判斷要不要補
            if(sub('.','',last(Player.Card.vt)) %in% c('10','11','12','13','1','8','9')){
              # 閒家補到0189 => 不需要補牌
              # 判定勝負
              Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
              # 計算龍七發生時，人工指標(特定牌卡濃度) 
              # 無觸發莊家補牌，因此無須計算指標
              # 儲存資料
              save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
              #Total.df = rbind(Total.df , save.vt)
              save.df <- rbind(save.df,save.vt)
              
            }else{
              # 閒家沒補到0189 => 要補牌
              sp.2 = sample(1:length(pool.0) , size=1 , replace = F)
              # 分派牌卡
              Banker.Card.vt[3] = pool.0[sp.2]
              # 更新莊家點數
              Banker.Points = sub('.','',Banker.Card.vt[1:3]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
              # 判定勝負
              Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
              # 計算龍七發生時，人工指標(特定牌卡濃度) 
              Highlight.index = ifelse(Game.Result=='Banker' && Banker.Points==7 ,'1','0')
              # 更新牌池
              pool.0 <- pool.0[-sp.2]
              # 儲存資料
              save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
              #Total.df = rbind(Total.df , save.vt)
              save.df <- rbind(save.df,save.vt)
            }
            
          }else if(Banker.Points==5){
            # 根據閒家補牌結果判斷要不要補
            if(sub('.','',last(Player.Card.vt)) %in% c('10','11','12','13','1','2','3','8','9')){
              # 閒家補到012389 => 不需要補牌
              # 判定勝負
              Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
              # 計算龍七發生時，人工指標(特定牌卡濃度) 
              # 無觸發莊家補牌，因此無須計算指標
              # 儲存資料
              save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
              #Total.df = rbind(Total.df , save.vt)
              save.df <- rbind(save.df,save.vt)
            }else{
              # 閒家沒補到012389 => 要補牌
              sp.2 = sample(1:length(pool.0) , size=1 , replace = F)
              # 分派牌卡
              Banker.Card.vt[3] = pool.0[sp.2]
              # 更新莊家點數
              Banker.Points = sub('.','',Banker.Card.vt[1:3]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
              # 判定勝負
              Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
              # 計算龍七發生時，人工指標(特定牌卡濃度) 
              Highlight.index = ifelse(Game.Result=='Banker' && Banker.Points==7 ,'1','0')
              # 更新牌池
              pool.0 <- pool.0[-sp.2]
              # 儲存資料
              save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
              #Total.df = rbind(Total.df , save.vt)
              save.df <- rbind(save.df,save.vt)
            }
          }else if(Banker.Points==6){
            # 根據閒家補牌結果判斷要不要補
            if(sub('.','',last(Player.Card.vt)) %!in% c('6','7')){
              # 閒家沒補到67 => 不需要補牌
              # 判定勝負
              Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
              # 計算龍七發生時，人工指標(特定牌卡濃度) 
              # 無觸發莊家補牌，因此無須計算指標
              # 儲存資料
              save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
              #Total.df = rbind(Total.df , save.vt)
              save.df <- rbind(save.df,save.vt)
            }else{
              # 閒家有補到67 => 要補牌
              sp.2 = sample(1:length(pool.0) , size=1 , replace = F)
              # 分派牌卡
              Banker.Card.vt[3] = pool.0[sp.2]
              # 更新莊家點數
              Banker.Points = sub('.','',Banker.Card.vt[1:3]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
              # 判定勝負
              Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
              # 計算龍七發生時，人工指標(特定牌卡濃度) 
              Highlight.index = ifelse(Game.Result=='Banker' && Banker.Points==7 ,'1','0')
              # 更新牌池
              pool.0 <- pool.0[-sp.2]
              # 儲存資料
              save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
              #Total.df = rbind(Total.df , save.vt)
              save.df <- rbind(save.df,save.vt)
            }
          }else{
            # 莊家拿7點 => 不用補牌
            # 判定勝負
            Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
            # 計算龍七發生時，人工指標(特定牌卡濃度) 
            # 無觸發莊家補牌，因此無須計算指標
            # 儲存資料
            save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
            #Total.df = rbind(Total.df , save.vt)
            save.df <- rbind(save.df,save.vt)
          }
          
        }else{
          
          # 閒家超過6點 => 不需要補牌
          
          # 莊家補牌套用閒家規則
          if(Banker.Points < 6 ){
            # 莊家小於6點 => 需要補牌
            sp.1 = sample(1:length(pool.0) , size=1 , replace = F)
            # 分派牌卡
            Banker.Card.vt[3] = pool.0[sp.1]
            # 更新莊家點數
            Banker.Points = sub('.','',Banker.Card.vt[1:3]) %>% as.numeric() %>% replace(., .>=10 , 0) %>% sum() %% 10
            # 判定勝負
            Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
            # 計算龍七發生時，人工指標(特定牌卡濃度) 
            Highlight.index = ifelse(Game.Result=='Banker' && Banker.Points==7 ,'1','0')
            # 更新牌池
            pool.0 <- pool.0[-sp.1]
            # 儲存資料
            save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
            #Total.df = rbind(Total.df , save.vt)
            save.df <- rbind(save.df,save.vt)
          }else{
            # 莊家大於等於6點 => 不需要補牌
            # 判定勝負
            Game.Result = ifelse(Player.Points > Banker.Points , 'Player' , ifelse(Banker.Points > Player.Points , 'Banker' , 'Even'))
            # 計算龍七發生時，人工指標(特定牌卡濃度) 
            # 無觸發莊家補牌，因此無須計算指標
            # 儲存資料
            save.vt = c(Player.Card.vt , Banker.Card.vt , Player.Points , Banker.Points , Game.Result , length(pool.0) , exp.index , Highlight.index)
            #Total.df = rbind(Total.df , save.vt)
            save.df <- rbind(save.df,save.vt)
          }
          
          
        }
        
        
        # 
        
      }
      
      # rm(pool.1,pool.2,pool.3,Game.Result,Highlight.index,Player.Card.vt,Player.Points,Banker.Card.vt,Banker.Points)
      # gc()
    }
    save.df <- save.df[-1,]
    return(save.df)

  }
})

stopCluster(cl = NULL)
Total.df <- do.call('rbind' , output)
head(Total.df)

Total.df %>% group_by(GameResult) %>% summarise(Cnts = n()) %>% mutate('Win.Rate%' = Cnts/sum(Cnts)*100)
