library(RMySQL)
library(igraph)
library(dplyr)
library("stringr")
library(e1071)

#connect to db
con <- dbConnect(RMySQL::MySQL(), 
                 username = "root",
                 password = "",
                 host = "127.0.0.1",
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



########## WORDCLOUD 
# use only positive tags 
# frequency is how many times they are used in total in entire data set

#subset for positive tags and take away "\r" at end of each tag
positiveTags <- scores.all[scores.all$predicted %in% 1,c(1,2)]
positiveTags$tagValue <- substr(positiveTags$tagValue, 1, nchar(positiveTags$tagValue)-1)

#calculate the no. of times each tag is used (for all tags)
by_tag <- group_by(user_tags, tagID)
tag_count <- as.data.frame(summarise(by_tag, tagCount=length(tagID)))

#find tag counts for just positive tags and order according to tag count
positiveTags_tagCount <- merge(positiveTags, tag_count, by.x="tagID", by.y="tagID")
positiveTags_tagCount <- positiveTags_tagCount[order(positiveTags_tagCount$tagCount, decreasing=TRUE),]

wordcloud(positiveTags_tagCount$tagValue[1:100], positiveTags_tagCount$tagCount[1:100], colors=brewer.pal(8,"Dark2"))


######### NETWORK GRAPHS
#calculate no. of users per artist 
# (we need to pick artists that have a reasonable no of users to make nice graphs)
by_artist <- group_by(user_artists, artistIDNEW)
artist_listens_usercount <- as.data.frame(summarise(by_artist, listen_count = sum(listens), users = length(userID)))

# Artist 1: artistID=3332, listen_count = 7056, no. of users = 23
# Find all users for this artist and their centrality number
#nodes
usersArtist3332 <- user_artists_centrality[user_artists_centrality$artistIDNEW==3332,]
rownames(usersArtist3332) <- NULL

#edges
aaa<- merge(usersArtist3332, user_friends, by.x="userID", by.y="userID")
edges <- aaa[aaa$friendID %in% usersArtist3332$userID, c(1,5)]

net <- graph.data.frame(edges, usersArtist3332, directed=FALSE)
V(net)$size <- V(net)$centrality*50 #set size of node corresponds to centrality
V(net)$label <- NA #get rid of node labels
graph_layout <- layout.fruchterman.reingold(net)
plot(net, vertex.color="orange", edge.color="grey50", edge.curved=0)

# Artist 2: artistID=3732, listen_count = 7059, no. of users = 10
# Find all users for this artist and their centrality number
#nodes
usersArtist3732 <- user_artists_centrality[user_artists_centrality$artistIDNEW==3732,]
rownames(usersArtist3732) <- NULL

#edges
aaa<- merge(usersArtist3732, user_friends, by.x="userID", by.y="userID")
edges <- aaa[aaa$friendID %in% usersArtist3732$userID, c(1,5)]

net <- graph.data.frame(edges, usersArtist3732, directed=FALSE)
V(net)$size <- V(net)$centrality*50 #set size of node corresponds to centrality
V(net)$label <- NA #get rid of node labels
graph_layout <- layout.fruchterman.reingold(net)
plot(net, vertex.color="orange", edge.color="grey50", edge.curved=0)

##Second try
# Artist 1: artistID=304, listen_count = 86,342, no. of users = 51
# Find all users for this artist and their centrality number
#nodes
usersArtist304 <- user_artists_centrality[user_artists_centrality$artistIDNEW==304,]
rownames(usersArtist304) <- NULL

#edges
aaa<- merge(usersArtist304, user_friends, by.x="userID", by.y="userID")
edges <- aaa[aaa$friendID %in% usersArtist304$userID, c(1,5)]

net <- graph.data.frame(edges, usersArtist304, directed=FALSE)
V(net)$size <- sqrt(V(net)$centrality)*15 #set size of node corresponds to centrality
V(net)$label <- NA #get rid of node labels
#graph_layout <- layout.fruchterman.reingold(net)
plot(net, vertex.color="orange", edge.color="grey50", edge.curved=0, main="David Archuleta: 86,342 listens")

# Artist 2: artistID=1400, listen_count = 86,195, no. of users = 143
# Find all users for this artist and their centrality number
#nodes
usersArtist1400 <- user_artists_centrality[user_artists_centrality$artistIDNEW==1400,]
rownames(usersArtist1400) <- NULL

#edges
aaa<- merge(usersArtist1400, user_friends, by.x="userID", by.y="userID")
edges <- aaa[aaa$friendID %in% usersArtist1400$userID, c(1,5)]

net <- graph.data.frame(edges, usersArtist1400, directed=FALSE)
V(net)$size <- sqrt(V(net)$centrality)*15 #set size of node corresponds to centrality
V(net)$label <- NA #get rid of node labels
#net_layout <- layout.fruchterman.reingold(net)
#net_layout <- layout.circle(net)
plot(net, vertex.color="orange", edge.color="grey50", edge.curved=0, main="MGMT: 86,195 listens")

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

wordcloud(tags304_sentiment$tagValue, tags304_sentiment$tagCount, ordered.colors=TRUE, colors=tags304_sentiment$colour, min.freq=1)


#plot wordcloud for MGMT (artistID=1400)
res <- dbSendQuery(con, "SELECT tagID FROM User_TagsFINAL WHERE artistIDNEW = 1400")
tags1400 <- dbFetch(res)
dbClearResult(res)

by_tag1400 <- group_by(tags1400, tagID)
tags1400_count <- as.data.frame(summarise(by_tag1400, tagCount = length(tagID)))

tags1400_sentiment <- subset(scores.all, tagID %in% tags1400_count[,1], select = c(tagID, tagValue, predicted))

tags1400_sentiment <- merge(tags1400_count, tags1400_sentiment, by.x="tagID", by.y="tagID")
tags1400_sentiment$tagValue <- substr(tags1400_sentiment$tagValue, 1, nchar(tags1400_sentiment$tagValue)-1)

tags1400_sentiment$colour[tags1400_sentiment$predicted==-1] <- "red"
tags1400_sentiment$colour[tags1400_sentiment$predicted==0] <- "grey80"
tags1400_sentiment$colour[tags1400_sentiment$predicted==1] <- "blue"

wordcloud(tags1400_sentiment$tagValue, tags1400_sentiment$tagCount, ordered.colors=TRUE, colors=tags1400_sentiment$colour, min.freq=1)





## Mucking around#### DON't RUN THIS CODE#####
#run queries
dbGetQuery(con, "SELECT * FROM Users WHERE userID < 20")

res <- dbSendQuery(con, "SELECT * FROM Users WHERE userID < 20")
dbFetch(res)
dbClearResult(res) #to free up memory 

#Read in entire table: >dbReadTable(con, "Users")

#Write a dataframe to db table: >dbWriteTable(con, "Users", dataframe[1:100, ])

#Read in a table, calculate some metric and add this as a new column to original table. 
#Note this code will not work since the "userID" col in x needs to come from the table. 
#Perhaps use dbReadTable...?
dbGetQuery(con, "SELECT * FROM Users")
dbSendQuery(con, "ALTER TABLE Users ADD COLUMN NewCol FLOAT")
x <- dataframe(userID=1:100, NewCol= 101:200)
dbWriteTable(con, "NewColUsers", x)
dbSendQuery(con, "UPDATE Users, NewColUsers 
            SET Users.NewCol=NewColUsers.NewCol 
            WHERE Users.userID=NewColUsers.userID")
dbGetQuery(con, "SELECT * FROM Users")


#dbFetch(dbSendQuery)
#dbClearResult(dbSendQuery)

#disconnect from db when done
on.exit(dbDisconnect(con))
