#### Lab Practice ####
# K type all data

# step.1 : input data
all_csv_k <- paste("D:/PeterWang/ML_Course/Examples/Data/K456/",list.files("D:/PeterWang/ML_Course/Examples/Data/K456/",pattern = ".csv"),sep="")

name_k = gsub("[[:punct:]]","",str_extract(list.files("D:/PeterWang/ML_Course/Examples/Data/K456/",pattern = "()"), "\\(.*?\\)"))

all_list_k <- lapply(all_csv_k,read_csv)

all_df_k <- do.call("rbind",all_list_k)

# step.2 : replicate Area name vector to new d.f.
name.vector = rep(name_k,each=unique(sapply(all_list_k, NROW)))

all_df_k <- cbind(all_df_k , Region=name.vector)
names(all_df_k)[1] <- "Date"
names(all_df_k)[3] <- "Counts"


all_df_k %>% mutate(Date = as.Date(paste(substr(all_df_k$Date,1,4),substr(all_df_k$Date,5,6),"01",sep = "-" )) , Counts = as.numeric(Counts) ) -> all_df_k

head(all_df_k)
str(all_df_k)

df.k <- all_df_k %>% dplyr::group_by(Date,Model) %>% dplyr::summarise(Counts=sum(Counts))
df.c <- all_df_c %>% group_by(Date,Model) %>% summarise(Counts=sum(Counts))
df <- rbind(df.k , df.c) %>% mutate(Date.Time = substr(as.character(Date),1,7))


# lab practice
ggplot(df, aes(x=Date.Time, y=Counts , fill=Model , group = Model )) +  # try adding width=.5 to aes(...)
  geom_bar(position = 'dodge', stat = 'identity') +
  geom_line(aes(group=Model,color=Model),size=1.1 )+
  #geom_line(aes(y=Counts , group=Model,color=Model),size=1.1 , position = position_dodge(width = 0.9))+
  geom_point(aes(group = Model) , size=1 )+
  #geom_point(aes(y=Counts , group = Model) , size=1 , position = position_dodge(width = .9))+
  geom_text(aes(label=Counts), position = position_dodge(width = 0.9) , vjust = -0.2)+
  #scale_x_date(date_breaks = "1 month", date_labels = "%Y-%m")+
  scale_fill_brewer(palette="YlOrRd")+
  #scale_fill_manual(values = c("#e97f02","#f8ca00"))+
  #scale_color_manual(values = c('#FF0000','#0000FF'))+
  #coord_flip()+
  theme_minimal()+
  theme(
    axis.text.x = element_text(size=8,vjust=1.0),
    axis.text.y = element_text(size=12,vjust=1.2),
    plot.title = element_text(size=18,face="bold",hjust=0.5),
    plot.subtitle = element_text(size=16,hjust=0.5),
    plot.caption = element_text(size=10),
    axis.title.x=element_text(size=14,face="bold"),
    axis.title.y=element_text(size=14,face="bold")
  )+
  labs(title="C123 & K456 Issued Cases Bar-Chart ",
       subtitle="Period from 2018.01 to 2019.08",
       caption="source: xxxx ; Author: PeterWang")
