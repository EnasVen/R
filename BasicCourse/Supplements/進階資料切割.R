library(readr)
# 讀取範例檔案
tmp.df <- read_csv(file.choose())



#### 方法1 (使用內件函數reshape + reshape2套件下的melt函數)####
library(reshape2)
# reshape格式非常複雜，很難第一時間看懂，主要用來做長寬轉換
# 第一個引數放入原始資料，吃data.frame型別，如果不是d.f.記得轉換 (read_csv load近來的資料會是tibble型別)
# 第二個引數direction : 指定現在的格是要轉成長型資料或是寬型資料
# 第三個引數varying : 放入需要被判斷的欄位名稱
# 第四個引數timevar : 放入拆解後的欄位名稱
# 第五個引數times : 放入主要被判斷的格式，以這個例子來說就是female和male
# 第六個引數v.names : 放入次要被判斷的格式，以這個例子來說就是Less20~60
# 第七個引數idvar : 放入每筆觀察值的id (可唯一決定每一筆觀察值的key欄位，比方說身分證字號、產品標籤序號...等等)
reshape(as.data.frame(tmp.df),
        direction='long',
        varying=c('female.Less20','female.Less40','female.Less60','male.Less20','male.Less40','male.Less60'),
        timevar='Sex',
        times=c('female', 'male'),
        v.names=c('Less20','Less40','Less60'),
        idvar='Observation') -> tmp.df2


# 由於reshape的功能限制，沒辦法一次將多個性別和多個Less拆開後各自訂成一個欄位，所以我們需要用melt把剩下的欄位堆起來!
melt(tmp.df2 , id.vars = c('Observation','Sex') , value.name = "Value")




#### 方法2 (使用課堂上沒教的套件--tidyr達成)####

# 這個套件專門用來對付難搞資料，屬於高階資料處理套件
library(tidyr)

# gather函數類似reshape2套件的 melt，把變數堆疊起來
# 第一個引數放入原始資料
# 第二個引數放入類別變數堆疊後的columns name
# 第三個引數放入數字觀察值的columns name
# 第四個引數放入每筆觀察值的id (可唯一決定每一筆觀察值的key欄位，比方說身分證字號、產品標籤序號...等等)
tmp.df_new <- gather(tmp.df , variable , count  ,-Observation) #沒加負號的話，該欄位也會被堆疊進去
head(tmp.df_new)

# seperate 會自動偵測格式，可以把指定column拆成不同形式
# 第一個引數放入需要被拆解的資料
# 第二個引數放入需要被拆解的欄位
# 第三個引數放入被拆解出來的欄位要用什麼名稱 (順序將依照原始被拆解欄位的格式進行，以這個例子來說就是性別+class)
separate(tmp.df_new , variable , c("sex","class"))


# 使用dplyr搭配tidyr直接一行完成
tmp.df %>% gather(. , type , value  ,-Observation) %>% separate(. , type , c("sex","class"))



# p.s. 可以的話分享給同學，算是進階資料處理的一個案例
