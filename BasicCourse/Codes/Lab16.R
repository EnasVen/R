######################################
####    CH16 - Graphic Skills     ####
######################################

#### CH 16.1 : Inherit Graphic Settings ####

#### CH 16.1 : Inherit Graphic Settings : par() ####

# dev.off can reset parameters
par( mai = c(1,2,3,4))
dev.off()
par()$mai

par( mfcol = c(3,2))
hist(sample(1:100 ,50 , replace = T))
hist(sample(10:100 ,50 , replace = T))
hist(sample(20:100 ,50 , replace = T))
hist(sample(30:100 ,50 , replace = T))
hist(sample(40:100 ,50 , replace = T))
hist(sample(50:100 ,50 , replace = T))


#### CH 16.1 : Inherit Graphic Settings : layout() ####

# try plots above
layout( matrix(  c(1,2,3,3) ,  2 , 2 , byrow=T)   )
layout( matrix(  c(3,0,1,2) ,  2 , 2 , byrow=T)  , widths = c(3,1) , heights = c(2,2)  )


#### ___________________________________________________________ ####
#### CH 16.2 : Inherit Graphic Func. ####

#### CH 16.2 : Inherit Graphic Func. : plot() ####

?plot

# plot func.
plot( mtcars$mpg , mtcars$qsec)
plot(sin , -2*pi , 2*pi)
plot(x <- factor(c("F","M","M","P")))
plot(x <- factor(c("F","M","M","P")) , y <- c(1,2,7,3))

# plot func. arguments
plot( mtcars$mpg , mtcars$qsec , main = 'test' , sub = 'okok' , cex = 5 , col = 'blue' ,
      col.main ='red',
      col.sub = 'firebrick' ,
      cex.axis = 2
)

plot( mtcars$mpg , mtcars$qsec , main = NULL , sub = 'okok' , cex = 5 , col = 'blue' ,
      col.main ='red',
      col.sub = 'firebrick' ,
      cex.axis = 2 ,
      xaxt='none',
      yaxt='none',  # remove x & y axis
      xlab='',
      ylab=''
)
axis(1, seq(0,30, 1),las=2, font=2,cex.axis=0.8)  #  add axis text by ourselves
axis(2, seq(0,70,10),las=2, font=2)
mtext(side=1, line=2, "X-axis label, bold, bigger", col="blue", font=2,cex=1.2)  #  add axis name by ourselves
mtext(side=2, line=3, "Y-axis label, bold, bigger", col="orange", font=2, cex=1.2)
mtext(side=3, line=0.5, "Main title, italic", col="forestgreen", font=3, cex=2)  #  add title by ourselves
text(x=17, y=20, 'Add some text, reduced font',col='gold4', font=2, cex=0.8)

# all data
plot(iris)
attach(mtcars) ; plot( ~mpg+wt+drat )


#### CH 16.2 : Inherit Graphic Func. : curve() ####

test <- function(x) (x^3)*exp(-sin(x))*tan(x)
curve(test , -100 , 100 , 2000)

hist( sample(-10:10 , 200 , replace = T))
curve( dnorm(x,5,1)*40 , col = 'red' , add = T)

f=function(x,p,n){
  tmp=pbinom(x, n, p, lower.tail = FALSE, log.p = FALSE) # Pr(X>x)
  #tmp=choose(n,x)*p^(x)*(1-p)^(n-x)
  return(tmp)
}
curve(f(x,0.05,100),from = 1 , to=100)

#### CH 16.2 : Inherit Graphic Func. : coplot() ####

coplot( mpg ~ qsec | gear  , rows =1)
coplot( mpg ~ qsec | factor(gear )  , rows =1)
attach(iris)
coplot(Sepal.Length~Sepal.Width|Species , rows = 1)


#### CH 16.2 : Inherit Graphic Func. : qqplot() ####

qqnorm(mpg , ylab='MPG' , main='qqnorm test plot')
qqline(mpg)
qqplot(mpg , drat)

#### CH 16.2 : Inherit Graphic Func. : hist() & barplot() ####

tmp <- chickwts %>%
        mutate(Category = cut(weight , breaks = seq(0,600,by=200) , labels = c('Low','Medium','High'))) %>%
        group_by(Category) %>%
        summarise(Counts = n())

barplot(tmp$Counts , names.arg = tmp$Category , col=c(1,2,3))

hist(chickwts$weight , breaks = c(0,200,400,600))

#### CH 16.2 : Inherit Graphic Func. : boxplot() & pie() ####

boxplot(Petal.Width~Species , col=c(1,3,5))
storage.vt <- c(0.2 , 0.15 , 0.35 , 0.1 , 0.2)

storage.vt <- c(0.2 , 0.15 , 0.35 , 0.1 , 0.2)
meat.vt <- c('牛肉' , '羊肉' , '雞肉' , '豬肉' ,'魚肉')
pie(storage.vt , meat.vt)


#### ___________________________________________________________ ####
#### CH 16.3 : Advanced Graphic Func. ####

#### CH 16.3 : Advanced Graphic Func. : Structure ####

# see text book

#### CH 16.3 : Advanced Graphic Func. : ggplot2 package  ####



rm(list=ls())
load.libraries <- c('dplyr','ggplot2','readr','lubridate','reshape2')
install.lib <- load.libraries[!load.libraries %in% installed.packages()]
for(libs in install.lib) install.packages(libs, dependences = TRUE)
sapply(load.libraries, require, character = TRUE)


#### Scatter plot ####

# prepare data
mtcars$gear <- factor(mtcars$gear)

ggplot(data = mtcars , aes(x = qsec , y = mpg , label = cyl)) +
  geom_point(aes(color = gear, size = mpg) , shape = 16) +
  facet_wrap( ~ gear , ncol = 1 , scales = "free" , strip.position = "bottom") + #, strip.position = "bottom"
  geom_label_repel(
    aes(fill = factor(cyl)),
    label.padding = 0.05,
    colour = "white",
    fontface = "bold" ,
    vjust = "inward",
    hjust = "inward"
  ) +
  scale_color_brewer(palette = "Dark2") +
  #scale_color_viridis_d()+ #可添加不同色調
  #scale_fill_manual(values = c('#6600CC', '#FF33FF', '#FF99CC') ,name = "cyl(factorized!)") +
  scale_fill_manual(values = c('blue', 'red', 'green') )+
  theme_gray() + #facet_grid(gear~vs , scales = "free")
  theme(
    axis.text.x = element_text(size = 8, vjust = 1.0),
    axis.text.y = element_text(size = 12, vjust = 1.2),
    plot.title = element_text(
      size = 18,
      face = "bold",
      hjust = 0.5,
      colour = 'navyblue',
      family = "mono"
    ),
    plot.subtitle = element_text(size = 16, hjust = 0.5),
    plot.caption = element_text(size = 10),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold")
  ) +
  labs(title = "Scatter plots of qsec vs mpg",
       subtitle = "Sorted by gear",
       caption = "source: mtcars ; Author: xxxx")


#### Line plot ####

# prepare data
all_csv_c <- paste("D:/PeterWang/ML_Course/Examples/Data/C123/",list.files("D:/PeterWang/ML_Course/Examples/Data/C123/",pattern = ".csv"),sep="")

name_c = gsub("[[:punct:]]","",str_extract(list.files("D:/PeterWang/ML_Course/Examples/Data/C123/",pattern = "()"), "\\(.*?\\)"))

all_list_c <- lapply(all_csv_c,read_csv)


# for filtering if needed
# clean <- function(x){
#   x %>% select(Year,Model,Sales_Qty)
# }
#
#
# all_list_c <- lapply(all_list_c,clean)
# all_list_c[1]


# C type all data
all_df_c <- do.call("rbind",all_list_c)

name.vector = rep(name_c,each=unique(sapply(all_list_c, NROW)))

all_df_c <- cbind(all_df_c , Region = name.vector)
head(all_df_c)
rownames(all_df_c) <- c()


names(all_df_c)[1] <- "Date"
names(all_df_c)[3] <- "Counts"

all_df_c %>% mutate(Date = as.Date(paste(substr(Date,1,4),substr(Date,5,6),"01",sep = "-" )) , Counts = as.numeric(Counts) ) -> all_df_c

head(all_df_c)
str(all_df_c)


nb.cols <- 15
mycolors <- colorRampPalette(brewer.pal(8, "Dark2"))(nb.cols)

ggplot(all_df_c , aes(x = Date, y = Counts, colour = Region , group = Region)) +
  geom_line(aes(group = Region),size = 0.8) +
  geom_point(colour='black') +
  scale_color_manual(values = mycolors) +
  scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m") +
  scale_y_continuous(breaks = seq(0, 200, 20)) +
  labs(
    x = "Date",
    y = "Sales Count" ,
    colour = "Region",
    title = "C123 Monthly Sales Trend",
    subtitle = "By Sales Region",
    caption = "source: 8787 ; Author: PeterWang"
  ) +
  theme(
    axis.text.x = element_text(size = 10, vjust = 0.4 , angle = 45),
    axis.text.y = element_text(size = 12, vjust = 1.2) ,
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    plot.caption = element_text(size = 10),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold"),
    #legend.title = element_blank(),
    #panel.border = element_rect(colour = "black", fill=NA),aspect.ratio = 1, axis.text = element_text(colour = 1, size = 12),
    legend.background = element_blank(),
    legend.box.background = element_rect(colour = "black")
  )

# 互動式圖表只需將上圖存成物件p，再用ggplotly(p)表示!


#### Histogram ####

# prepare data
set.seed(1234)
df <- data.frame(
  sex=factor(rep(c("F", "M"), each=200)),
  weight=round(c(rnorm(200, mean=55, sd=5), rnorm(200, mean=65, sd=5)))
)
head(df)

library(plyr)
mu <- ddply(df, "sex", summarise, grp.mean=mean(weight))
head(mu)

# hist-ex1
ggplot(df, aes(x = weight, color = sex, fill = sex)) +
  geom_histogram(aes(y = ..density..), position = "identity", alpha = 0.5) +
  geom_density(alpha = 0.6) +
  geom_vline(data = mu,
             aes(xintercept = grp.mean, color = sex),
             linetype = "dashed") +
  scale_color_manual(values = c("#999999", "#E69F00", "#56B4E9")) +
  scale_fill_manual(values = c("#999999", "#E69F00", "#56B4E9")) +
  labs(title = "Weight histogram plot", x = "Weight(kg)", y = "Density") +
  theme_classic()

# hist-ex2
ggplot(diamonds, aes(price, fill = cut)) +
  geom_histogram(binwidth = 500)


#### Barplot ####

# prepare data
DF <- data.frame(Name = c('A','A','B','B','C','C'),
                 TotalDemand = c(27,23,16,9, 32, 40),
                 Pop = c("TEST", "CONTROL", "TEST", "CONTROL", "TEST", "CONTROL"))

# bar-ex1
ggplot(DF, aes(x = Name, y = TotalDemand, fill=Pop , label = TotalDemand)) +
  geom_bar(stat = "identity") +
  geom_text(size=3.5 , position = position_stack(vjust=0.5) , fontface = 'bold')+
  scale_fill_brewer(palette = "Set1")

ggplot(DF, aes(x = Name,  fill=Pop , label = TotalDemand)) +
  geom_bar()


ggplot(DF, aes(x = Name, y = TotalDemand, fill = Pop)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = TotalDemand, y = TotalDemand - 3),
            nudge_x = c(0.22,-0.22)) +
  coord_flip()


#### Boxplot ####

# prepare data
DF.2 <- data.frame(Name = sample(letters[1:10] , 100 , replace = T),
                   Value = rnorm(100 , 5 , 10))

# Boxplot-ex1
ggplot(DF.2, aes(x=Name, y=Value , fill=Name)) +
  geom_boxplot()+
  geom_dotplot(binaxis='y',
               stackdir='center',
               dotsize = .5,
               binwidth = 2,
               color="white",
               fill="black") +
  theme(axis.text.x = element_text(vjust=0.6 , size = 12)) +
  labs(title="Box plot + Dot plot",
       subtitle="Test Data",
       caption="Source: xxx")


#### Pie Chart ####

data <- data.frame(
  group=LETTERS[1:5],
  value=c(13,7,9,21,2)
)

# Compute the position of labels
data <- data %>%
  arrange(desc(group)) %>%
  mutate(prop = value / sum(data$value) *100) %>%
  mutate(ypos = cumsum(prop)- 0.5*prop )

# Pie Chart-ex1
ggplot(data, aes(x="", y=prop, fill=group)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=90) +
  theme_void() +
  theme(legend.position="none") +
  geom_text(aes(y = ypos, label = paste(group,'\n',round(prop,2))), color = "white", size=6) +
  scale_fill_brewer(palette="Set1")


# data prepare
labels = c('Oxygen','Hydrogen','Carbon_Dioxide','Nitrogen')
values = c(4500, 2500, 1053, 500)

# Pie Chart-ex2
fig <- plot_ly(type='pie', labels=labels, values=values,
               textinfo='label+value+percent')
fig


tmp.df <- data.frame(
  "Area"=c(" ","AU","BE","CN","HQ","JP","KR","ME","PL","RU","TR","TW","UK","US"),
  "Value"=c(291,350,904,220,167,617,592,261,126,209,125,171,352,140)
)
tmp.df %>%
  arrange(desc(Value)) %>%
  mutate(Area=factor(Area,levels=Area),all.count=sum(Value)) %>%
  plot_ly(labels=~Area,values=~Value,type="pie",textposition="outside",textinfo="label+value+percent")%>%
  layout(title='<b>Pie Chart for Test Data</b>  <br>(By Area)'
  #annotations=list(x=1.35,y=-0.05,xref='paper',yref='paper',text=paste('Source from ', "ATEN eSupport System", " | Author:PeterWang",sep=""),showarrow=F )
  )

# data prepare
library(plotly)
library(dplyr)
mtcars$manuf <- sapply(strsplit(rownames(mtcars), " "), "[[", 1)

# Pie Chart-ex3
df <- mtcars
df <- df %>% dplyr::group_by(manuf) %>% dplyr::summarise(count = n())

fig <- df %>% plot_ly(labels = ~manuf, values = ~count , textposition="outside")
fig <- fig %>% add_pie(hole = 0.6)
fig <- fig %>% layout(title = "Donut charts using Plotly",  showlegend = T)
fig

#### Correlation Heat Map ####

# Correlation Heat Map-ex1
library(corrplot)
M<-cor(mtcars[,1:5])
head(round(M,2))

# method = "circle""
corrplot(M, method = "square")

corrplot.mixed(M, order="hclust", tl.col="black")
corrplot(M, type = "upper", order = "hclust", tl.col = "darkblue", tl.srt = 0)
corrplot(M, type = "lower")

corrplot(M, type = "upper", order = "hclust",
         col = brewer.pal(n = 9, name = "PuOr"), bg = "darkgreen")

col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(M, method = "color", col = col(200),
         type = "upper", order = "hclust",
         addCoef.col = "black", # Add coefficient of correlation
         tl.col = "darkblue", tl.srt = 45, #Text label color and rotation
         # hide correlation coefficient on the principal diagonal
         diag = F
)


# Correlation Heat Map-ex2
install.packages('GGally')
library(GGally)
ggcorr(M, nbreaks=8, palette='RdGy', label=TRUE, label_size=5, label_color='white')
detach("package:GGally", unload=TRUE)

# Correlation Heat Map-ex3
library("PerformanceAnalytics")
chart.Correlation(mtcars[,1:5], histogram=TRUE, pch=19)


# Correlation Heat Map-ex4
library(GGally)
ggpairs(mtcars)

# ggpairs is powerful on visualization of grouped data !
data(flea)
ggpairs(flea, columns = 2:4, ggplot2::aes(colour=species))

data(tips, package = "reshape")
ggpairs(tips, 1:3, columnLabels = c("Total Bill", "Tip", "Sex"))


#### 3D Plot ####
library(plotly)

# 3D - scatter plot
mtcars$am[which(mtcars$am == 0)] <- 'Automatic'
mtcars$am[which(mtcars$am == 1)] <- 'Manual'
mtcars$am <- as.factor(mtcars$am)

fig <- plot_ly(mtcars, x = ~wt, y = ~hp, z = ~qsec, color = ~am, colors = c('#BF382A', '#0C4B8E'))
fig <- fig %>% add_markers()
fig <- fig %>% layout(scene = list(xaxis = list(title = 'Weight'),
                                   yaxis = list(title = 'Gross horsepower'),
                                   zaxis = list(title = '1/4 mile time')))

fig

# 3D - scatter plot
fig <- plot_ly(mtcars, x = ~wt, y = ~hp, z = ~qsec,
               marker = list(color = ~mpg, colorscale = c('#FFE1A1', '#683531'), showscale = TRUE))
fig <- fig %>% add_markers()
fig <- fig %>% layout(scene = list(xaxis = list(title = 'Weight'),
                                   yaxis = list(title = 'Gross horsepower'),
                                   zaxis = list(title = '1/4 mile time')),
                      annotations = list(
                        x = 1.13,
                        y = 1.05,
                        text = 'Miles/(US) gallon',
                        xref = 'paper',
                        yref = 'paper',
                        showarrow = FALSE
                      ))
fig

#### ___________________________________________________________ ####
#### Appendix : User-defined plotting ####

cubeFun <- function(x) {
  -log(x,base=2)
}


p9 <- ggplot(data.frame(x = c(0, 1)), aes(x = x)) +
  # scale_x_continuous(limits = c(0, 1),breaks = seq(0,1,0.1))+
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 8, vjust = 1.0),
    axis.text.y = element_text(size = 12, vjust = 1.2),
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 16, hjust = 0.5),
    plot.caption = element_text(size = 10),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold")
  ) +
  labs(
    x = "Probability",
    y = "Information Quantity" ,
    title = "Information Plot",
    subtitle = "I(X)=-ln(P(X))",
    caption = "source: Custom ; Author: PeterWang"
  ) +
  #geom_vline(xintercept=0.5, linetype="dashed", color = "blue", size=1)+
  stat_function(fun = cubeFun)
p9

entropy.func <- function(p) {
  -p * log2(p) - (1 - p) * log2(1 - p)
}

p9 <- ggplot(data.frame(x = c(0, 1)), aes(x = x)) +
  # scale_x_continuous(limits = c(0, 1),breaks = seq(0,1,0.1))+
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 8, vjust = 1.0),
    axis.text.y = element_text(size = 12, vjust = 1.2),
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 16, hjust = 0.5),
    plot.caption = element_text(size = 10),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold")
  ) +
  labs(
    x = "Probability",
    y = "H(X)" ,
    title = "Entropy Plot",
    subtitle = "H(X)=-[P(X)*ln(P(X))+(1-P(X)*ln(1-P(X)))]",
    caption = "source: Custom ; Author: PeterWang"
  ) +
  geom_vline(
    xintercept = 0.5,
    linetype = "dashed",
    color = "blue",
    size = 1
  ) +
  stat_function(fun = entropy.func)
p9


#
expect.func <- function(p) {
  (1-(1-p)**300)/p
}


r = ggplot(data.frame(x = c(0, .1) ), aes(x = x )) +
  # scale_x_continuous(limits = c(0, 1),breaks = seq(0,1,0.1))+
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 8, vjust = 1.0),
    axis.text.y = element_text(size = 12, vjust = 1.2),
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 16, hjust = 0.5),
    plot.caption = element_text(size = 10),
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(size = 14, face = "bold")
  ) +
  scale_y_continuous(breaks = seq(0, 500, 20)) +
  labs(
    x = "Probability",
    y = "Expected Draws" ,
    title = "保底期望抽數圖",
    subtitle = "某個很香的手遊",
    caption = "source: Custom ; Author: PeterWang"
  ) +
  geom_vline(
    aes(xintercept = 0.007,color = "SSR.Prob"),
    linetype = "dashed",
    size = 1
  ) +
  scale_color_manual(name = " ", values = c(SSR.Prob = "darkred"))+
  annotate("text", label = "p=0.007", x = 0.014, y = 260 , size = 6 , colour = "navyblue")+
  stat_function(fun = expect.func)

ggplotly(r) #%>%
  # layout(annotations =
  #          list(x = 0.66, y = 1.05, text = "Source: xxx",
  #               showarrow = F, xref='paper', yref='paper',
  #               xanchor='right', yanchor='auto', xshift=0, yshift=0,
  #               font=list(size=15, color="red"))
  # )


# Different functions
type1 <- function(x,p=0.2) {
  x*0.8+x*0.2*2
}

type2 <- function(x,p=0.5) {
  x*0.5+x*0.5*1.5
}


p <- ggplot(data = data.frame(x = c(1000,40000)), mapping = aes(x = x))

p <- p +
  stat_function(fun=type1,mapping =  aes(colour="Method1")) +
  stat_function(fun=type2,mapping = aes(colour="Method2"))
ggplotly(p)

