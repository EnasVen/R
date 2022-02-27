### 時間型別補充 ###

# 一般來說，通用標準格式會長這樣　年-月-日 時:分:秒 or 年/月/日 時:分:秒


#### as.Date(...) ####

# as.Date最大特色是轉換成年-月-日呈現
#首先變更系統時間至英語系顯示
prev <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C") # Sys.setlocale("LC_TIME", prev) ... 回復初始設定用

# as.Date在Default狀況下，需要輸入 年/月/日 或者 年:月:日，否則會出error
as.Date('2010-1-18') # ok!
as.Date('2009/09/25') # ok!
as.Date('20:13:03 2017-01-28') # Error
as.Date('23-2013-1') # Error

# 即使字串格式非標準，在告知順序以及內容之後，仍能正常輸出!
as.Date('23-2013-1', format='%d-%Y-%m')
# [1] "2013-01-23"
as.Date('20:13:03 2017-01-28', format='%H:%M:%S %Y-%m-%d')
# [1] "2017-01-28"
as.Date("Tue, 23 Mar 2010 14:36:38", format="%a, %d %b %Y %H:%M:%S")
# [1] "2010-03-23"

# 設定吃中文時間格式之後試試看 :
Sys.setlocale(category = "LC_TIME", locale = "cht")
as.Date("Tue, 23 Mar 2010 14:36:38", format="%a, %d %b %Y %H:%M:%S")
# [1] NA
as.Date("週二, 23  三月 2010 14:36:38", format="%a, %d %b %Y %H:%M:%S")
# [1] "2010-03-23"


#### format(...) ####

# format用來做時間格式的轉換，提取有用的資訊
# 在format引數設定我們想要抓取、變換後的訊息
now <-Sys.time()
format(now , format="%B-%d-%Y")
# [1] "十一月-11-2020"

format(now , format="%C/%B/%d  %a|%W|%p")
# [1] "20/十一月/11  週三|45|上午"  ... 中文時間顯示結果
# [1] "20/November/11  Wed|45|AM"   ... 英文時間顯示結果

#format後得到的物件不是時間型別，是純字串!
class(format(now , format="%R"))
# [1] "character"

# as.Date也可以搭配format做時間格式的輸出!
as.Date( format(now , format="%C/%B/%d  %a|%W|%p") , format = '%C/%B/%d  %a|%W|%p'    )
as.Date( format(now , format="%C/%B/%d  %a|%W|%p") , format = '%C/%B/%d'    )



#### POSIXct / POSIXlt ####
# 資料含有日期+時間的資訊時，我們如果想要同時使用這樣的資料，就必須準備時間專用的型別來儲存日期+時間
# POSIXct / POSIXlt 就是R語言裡面用來儲存時間的標準格式(年-月-日 時:分:秒 時區)


# POSIXlt
# POSIXlt 將時間的各項資訊拆分，以list儲存

# unclass函數可以將POSIXlt的元素展開
as.POSIXlt(now)
unclass(as.POSIXlt(now))

# POSIXct
# POSIXct 將時間自1970-01-01開始，以秒的方式儲存
as.POSIXct(now)
as.POSIXct(86400, origin = "1970-01-01", tz = "UTC")

# unclass函數對Xct使用會得到一個數字，代表從1970-01-01經過了多少秒
unclass(as.POSIXct(now))


#丟入非標準的時間資料，Xct與Xlt都能回傳標準時間格式
as.POSIXct("Tue, 23 Mar 2010 02:36:38 pm" , format = "%a, %d %b %Y %I:%M:%S %p")  # 有am pm資訊記得要換成 %I
as.POSIXlt("Tue, 23 Mar 2010 02:36:38 pm" , format = "%a, %d %b %Y %I:%M:%S %p")


# format/as.Date 與 POSIX的搭配
as.POSIXlt( format(now , format="%C/%B/%d  %a|%W|%p") , format = "%C/%B/%d  %a|%W|%p")
# [1] "2000-11-11 CST"
format( as.POSIXct(now) , format = '%Y-%M-%d %H:%M:%OS3')
# [1] "2020-11-11 10:1157.579"
as.POSIXlt( as.Date(now))


# POSIXlt 可以查看不同地區的當地時間
OlsonNames()  # 可用時區名稱
as.POSIXlt(Sys.time(), tz="America/New_York")
as.POSIXlt(Sys.time(), tz="Asia/Taipei")

# 時間平移
Sys.time() + 60*60   #以秒計
Sys.time() + days(5) #lubridate套件功能
Sys.time() + hours(5) #lubridate套件功能


#### strptime ####
# strptime 回傳的物件型別是POSIX
strptime("2006-01-08 10:07:52", format = "%Y-%m-%d")
class(strptime("2006-01-08 10:07:52", "%Y-%m-%d"))
# [1] "POSIXlt" "POSIXt"

strptime("Wed Nov 11 13:28:38 2020", format = "%a %b %d %H:%M:%S %Y")
strptime("Wed Nov 11 13:28:38 2020", format = "%a %b %H:%M:%S %Y") # wrong format will cause NA

