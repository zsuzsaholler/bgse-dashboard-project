library(RMySQL)
library(igraph)
library(dplyr)
library("stringr")
library(e1071)

#connect to db
con <- dbConnect(RMySQL::MySQL(), 
                 username = "root",
                 password = "root",
                 host = "localhost",
                 port = 3306,
                 dbname = "mydb")

#Show tables
#dbListTables(con, mydb)

########## Dependent Variable - Listen Counts per Artists
user_artists <- dbReadTable(con, "User_ArtistsFINAL")
by_artist <- group_by(user_artists, artistIDNEW)
X0 <- as.data.frame(summarise(by_artist, listen_count = sum(listens)))

########## Centrality
user_friends <- dbReadTable(con, "User_Friends")
graph <- graph.data.frame(user_friends)

s641_social_undirected <- as.undirected(graph, mode='collapse')
ev_obj_social <- evcent(s641_social_undirected)
eigen_social <- ev_obj_social$vector
user_centrality <- data.frame(as.numeric(V(graph)$name),eigen_social)
colnames(user_centrality) <- c("userID", "centrality")

user_artists_centrality <- merge(user_artists, user_centrality, by.x="userID", by.y="userID")
by_artist <- group_by(user_artists_centrality, artistIDNEW)
X1 <- as.data.frame(summarise(by_artist, mean_user_central = mean(centrality)))

########## Tag sentiment analysis
tags <- dbReadTable(con, "Tags")

#Loading in tag sample with sentiments assigned
tags.classified <- dbReadTable(con, "Tags_Classified")
tags.classified[3] = as.factor(tags.classified[,3])

afin_list <- dbReadTable(con, "Afin_Words")
names(afin_list) <- c('word', 'score')

afin_list$word <- tolower(afin_list$word)
#Split word list by sentiment
afin_list_split = split(afin_list,afin_list[,"score"])
afin_list_split = afin_list_split[-6]

#Function to count number of words in each tag matching the elements of a word list 
sentimentScore <- function(sentences, terms){
    final_scores <- matrix('', 0, 3)
    sentences = as.matrix(sentences)
    terms = unlist(terms)
    scores <- apply(sentences,1, function(sentence, terms){
        initial_sentence <- sentence
        sentence <- sentence[2]
        #remove unnecessary characters and split up by word 
        sentence <- gsub("-"," ",sentence)
        sentence <- gsub("[^A-Za-z ]","",sentence)
        sentence <- gsub('[[:punct:]]', '', sentence)
        sentence <- gsub('[[:cntrl:]]', '', sentence)
        sentence <- gsub('\\d+', '', sentence)
        sentence <- tolower(sentence)
        wordList <- str_split(sentence, '\\s+')
        words <- unlist(wordList)
        #build vector with matches between sentence and each category
        Matches <- match(words, terms)
        #sum up number of words in each category
        Matches <- sum(!is.na(Matches))
        #add row to scores table
        #newrow <- c(initial_sentence, Matches)
        return(Matches)
    }, terms)
    return(data.frame(sentences,scores))
}

#Training Naive Bayes classifier
##Run sentimentScore function on tag sample
scores.classification = tags.classified
i=0
for (elements in afin_list_split) {
    i=i+1
    sentiment = elements[1,2]
    scores.classification = cbind(scores.classification, sentimentScore(tags.classified[,1:2],elements[,1])[,3])
    names(scores.classification)[i+3] = sentiment
}

scores.classification[,4:13] = scores.classification[,4:13] > 0
scores.classification[,4:13] = lapply(scores.classification[,4:13],function(x){factor(x,levels=c("TRUE","FALSE"))})

##Split sample data to training and test set 
train.sample = sample(unlist(scores.classification[,1]),200)
train.sample = scores.classification$tagID %in% train.sample
scores.classification.train = scores.classification[train.sample,]
scores.classification.test = scores.classification[!train.sample,]
##run the naive bayes algorithm using 10 categories of words from (-5 to 5)
##and sentiments positive-neutral-negative (1 0 -1) for tags
classifier <- naiveBayes(scores.classification.train[,4:13], unlist(scores.classification.train[,3]))
scores.classification = cbind(scores.classification , predicted = predict(classifier, scores.classification[,4:13]))
##display the confusion table for the classification ran on training and test data
confTable.train <- table(predict(classifier, scores.classification.train[,4:13]), unlist(scores.classification.train[,3]),
                         dnn=list('predicted','actual'))
confTable.test <- table(predict(classifier, scores.classification.test[,4:13]), unlist(scores.classification.test[,3]),
                        dnn=list('predicted','actual'))
#ideas to make it better: remove band names and genres, add words from the classified set
confTable.train
confTable.test

#Run classification on all of the tags
scores.all = tags
i=0
for (elements in afin_list_split) {
    i=i+1
    sentiment = elements[1,2]
    scores.all = cbind(scores.all, sentimentScore(tags,elements[,1])[,3])
    names(scores.all)[i+2] = sentiment
}

scores.all[,3:12] = scores.all[,3:12] > 0
scores.all[,3:12] = lapply(scores.all[,3:12],function(x){factor(x,levels=c("TRUE","FALSE"))})

scores.all = cbind(scores.all , predicted = predict(classifier, scores.all[,3:12]))

user_tags <- dbReadTable(con, "User_TagsFINAL")
user_tags_sentiment <- merge(user_tags, scores.all, by.x="tagID", by.y="tagID")
by_artist <- group_by(user_tags_sentiment, artistIDNEW)
X2 <- as.data.frame(summarise(by_artist, positive_tags = sum(predicted %in% 1), positive_to_total_tags = positive_tags/sum(predicted %in% c(-1,0,1))))


########## Tag count of users
by_user <- group_by(user_tags, userID)
usertag_count <- as.data.frame(summarise(by_user, tagCount=length(tagID) ))

user_artists_usertag_count <- merge(user_artists, usertag_count, by.x="userID", by.y="userID")
by_artist <- group_by(user_artists_usertag_count, artistIDNEW)
X3 <- as.data.frame(summarise(by_artist, avg_tag_count = mean(tagCount)))

RegressionVars <- merge(X2, X3, by.x="artistIDNEW", by.y="artistIDNEW")
RegressionVars <- merge(X1, RegressionVars, by.x="artistIDNEW", by.y="artistIDNEW")
RegressionVars <- merge(X0, RegressionVars, by.x="artistIDNEW", by.y="artistIDNEW")


######### NETWORK GRAPHS

#plot wordcloud for David Archuleta (artistID=304)
res <- dbSendQuery(con, "SELECT tagID FROM User_TagsFINAL WHERE artistIDNEW = 304")
tags304 <- dbFetch(res)
dbClearResult(res)

by_tag304 <- group_by(tags304, tagID)
tags304_count <- as.data.frame(summarise(by_tag304, tagCount = length(tagID)))

tags304_sentiment <- subset(scores.all, tagID %in% tags304_count[,1], select = c(tagID, tagValue, predicted))

tags304_sentiment <- merge(tags304_count, tags304_sentiment, by.x="tagID", by.y="tagID")
tags304_sentiment$tagValue <- substr(tags304_sentiment$tagValue, 1, nchar(tags304_sentiment$tagValue)-1)

tags304_sentiment$colour[tags304_sentiment$predicted==-1] <- "red"
tags304_sentiment$colour[tags304_sentiment$predicted==0] <- "grey80"
tags304_sentiment$colour[tags304_sentiment$predicted==1] <- "blue"

args                 <- commandArgs(TRUE)
charts.partial.path  <- args[1]
artist.id           <- args[2]
filename = paste0(charts.partial.path, ".", "wordcloud", ".png", sep="")
png(file= filename, width=800, height=800 )
wordcloud(tags304_sentiment$tagValue, tags304_sentiment$tagCount, ordered.colors=TRUE, colors=tags304_sentiment$colour, min.freq=1)
dev.off()

#disconnect from db when done
on.exit(dbDisconnect(con))
