#### Lab Bonus Course Text Mining ####
rm(list=ls())
load.libraries <- c('dplyr','ggplot2','readr','stringr','tm','wordcloud','wordcloud2','gridExtra','lubridate')
install.lib <- load.libraries[!load.libraries %in% installed.packages()]
for(libs in install.lib) install.packages(libs, dependences = TRUE)
sapply(load.libraries, require, character = TRUE)

news <- read_csv('D:/PeterWang/ML_Course/Examples/Data/news.csv')
head(news)

df0 <- news
df0$Text <- iconv(df0$Text, "CP950", "UTF-8")

df0$Text <- str_trim(df0$Text)
df0$Text <- gsub("-", " ", df0$Text)
df0$Text <- gsub('\n', " ", df0$Text)
df0$Text <- gsub("<.*?>", "", df0$Text)
df0$Text <- gsub('"', "", df0$Text)
df0$Text <- gsub("[[:punct:]]", "", df0$Text)
df0$Text<- trimws(df0$Text)
df0$Text<- gsub("<U+.*?>"," ",df0$Text)

head(df0)

# Transform to Corpus object
df_corpus = Corpus(VectorSource(df0$Text))
print(df_corpus)

# Warning is okay , cuz it just check if the length of doc matches number of names of corpus object.
corpus_clean = tm_map(df_corpus, content_transformer(tolower))
corpus_clean = tm_map(corpus_clean,removeNumbers)
corpus_clean = tm_map(corpus_clean,removePunctuation)
corpus_clean = tm_map(corpus_clean, removeWords, c("chorus","instrumental","verse","get","dont","can","just","know","like","come","make","say","cant","will","the","and",stopwords("english")))
corpus_clean = tm_map(corpus_clean,stripWhitespace)
corpus_clean = tm_map(corpus_clean, stemDocument, language = "english")

# Use inspecr func. to view content , cant use simple indexing
inspect(corpus_clean[1])
#[1] healthi babi born mother infect novel coronavirus one...

#check results
lapply(df_corpus[2],as.character) #before
lapply(corpus_clean[2],as.character) #after

#Construct words sparse matrix
df_dtm = DocumentTermMatrix(corpus_clean,control = list(weighting = weightTfIdf))
#df_dtm = DocumentTermMatrix(corpus_clean,control = list(weighting = weightTf))
df_dtm
# <<DocumentTermMatrix (documents: 5, terms: 345)>>
#   Non-/sparse entries: 380/1345
# Sparsity           : 78%
# Maximal term length: 12
# Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

# Take a look
# way 1
idx = which(dimnames(df_dtm)$Term == "social")
as(df_dtm[1:5,idx:(idx+10)],"matrix")

# way 2
inspect(df_dtm[1:5, 100:105])
fm = as(df_dtm,"matrix")

# remove sparse terms
df_dtm2 <- removeSparseTerms(df_dtm, 0.70)
df_dtm2
# <<DocumentTermMatrix (documents: 5, terms: 34)>>
#   Non-/sparse entries: 69/101
# Sparsity           : 59%
# Maximal term length: 11
# Weighting          : term frequency - inverse document frequency (normalized) (tf-idf)

# see the most frequent terms
findFreqTerms(df_dtm)

# simple wordcloud
freq <- data.frame(sort(colSums(as.matrix(df_dtm))))
rainbowLevels <- rainbow(length(freq[,1]))
wordcloud(rownames(freq), freq[,1], max.words=500,random.order=F, colors=rainbowLevels)
wordcloud(rownames(freq), freq[,1], max.words=500, colors=brewer.pal(1, "Dark2"))

# advanced wordcloud
DF <- data.frame(word=rownames(freq), count=freq)
rownames(DF) <- rownames(freq)
colnames(DF)[2] <- 'freq'
DF %>% dplyr::arrange(-freq) -> DF # try not run this code to see difference among plots

wordcloud2::wordcloud2( DF  ,color = "random-light", backgroundColor = "grey" )
wordcloud2::wordcloud2( DF  ,color = "random-light", backgroundColor = "grey" , size = .5 ,shape = 'star')

