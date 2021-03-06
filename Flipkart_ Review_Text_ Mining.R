


############  Extract Flipkart Samsung mobile reviews & sentiment analysis on it by Text Mining ############

install.packages(c("rvest","XML","magrittr"))
library(rvest)
library(XML)
library(magrittr)

##Flipkart Reviews 
furl <- "https://www.flipkart.com/samsung-galaxy-note-20-ultra-5g-mystic-black-256-gb/product-reviews/itme2a64f28d2ae6?pid=MOBFU5WYPMCGAZ6J&lid=LSTMOBFU5WYPMCGAZ6JTZLDGQ&marketplace=FLIPKART&page"
flipkart_reviews <- NULL
for (i in 1:2){
  murl <- read_html(as.character(paste(furl,i,sep="=")))
  rev <- murl %>% html_nodes(".qwjRop") %>% html_text()
  flipkart_reviews <- c(flipkart_reviews,rev)
}

length(flipkart_reviews)
write.table(flipkart_reviews,"samsung.txt",row.names = F)
getwd()


#Setup the environment
install.packages("tm")  # for text mining
install.packages(c("SnowballC","textstem")) # for text stemming
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes

library('tm')
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library('textstem')

#Importing apple reviews data
x <- as.character(flipkart_reviews)
x <- iconv(x, "UTF-8")

# Load the data as a corpus
x <- Corpus(VectorSource(x))
inspect(x[1])

# Convert the text to lower case
x1 <- tm_map(x, tolower)
inspect(x1[1])
# Remove numbers
x1 <- tm_map(x1, removeNumbers)
# Remove punctuations
x1 <- tm_map(x1, removePunctuation)
# Remove english common stopwords
x1 <- tm_map(x1, removeWords, stopwords('english'))
# Remove your own stop word
# specify your stopwords as a character vector
x1 <- tm_map(x1, removeWords, c("apple", "mac","the","will")) 
#striping white spaces
x1 <- tm_map(x1, stripWhitespace)
inspect(x1[1])
# Text lemmatization
x1<-lemmatize_words(x1)

# Term document matrix 
# converting unstructured data to structured format using TDM
tdm <- TermDocumentMatrix(x1)
tdm <- as.matrix(tdm)

#Frequency of term documents 
v <- sort(rowSums(tdm),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# Bar plot of TDM 
w <- rowSums(tdm)
w_sub <- subset(w, w >= 1)
barplot(w_sub, las=3, col = rainbow(20))
# Term samsung galaxy repeats in all most all documents
x1 <- tm_map(x1, removeWords, c('samsung','galaxy',"mobile",'can','will',"flipkart",'ultra','5g','product'))
x1 <- tm_map(x1, stripWhitespace)
tdm <- TermDocumentMatrix(x1)
tdm <- as.matrix(tdm)
w1 <- rowSums(tdm)

# Word cloud
#With all the words

wordcloud(words = names(w1), freq = w1, 
          random.order = F, colors = rainbow(20), 
          scale=c(2,.2), rot.per = 0.3)

# lOADING +VE AND -VE dictonaries
pos.words = scan(file.choose(), what="character", comment.char=";")	# read-in positive-words.txt
neg.words = scan(file.choose(), what="character", comment.char=";") 	# read-in negative-words.txt
pos.words = c(pos.words,"wow", "kudos", "hurray") # including our own positive words to the existing list

# Positive wordcloud
pos.matches = match(names(w), c(pos.words))
pos.matches = !is.na(pos.matches)
freq_pos <- w[pos.matches]
p_names <- names(freq_pos)

wordcloud(p_names,freq_pos,scale=c(3.5,.5),colors = rainbow(20))

# Negative wordcloud
neg.matches = match(names(w), c(neg.words))
neg.matches = !is.na(neg.matches)
freq_neg <- w[neg.matches]
n_names <- names(freq_neg)
wordcloud(n_names,freq_neg,scale=c(3.5,.5),colors = brewer.pal(8,"Dark2"))

#Association between words
tdm <- TermDocumentMatrix(x1)
findAssocs(tdm, c("battery"),corlimit = 0.3)




