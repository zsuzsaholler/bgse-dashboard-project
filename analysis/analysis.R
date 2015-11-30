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

########## Centrality
user_friends <- dbReadTable(con, "User_Friends")
graph <- graph.data.frame(user_friends)

s641_social_undirected <- as.undirected(graph, mode='collapse')
ev_obj_social <- evcent(s641_social_undirected)
eigen_social <- ev_obj_social$vector
user_centrality <- data.frame(as.numeric(V(graph)$name),eigen_social)
colnames(user_centrality) <- c("userID", "centrality")
user_artists <- dbReadTable(con, "User_ArtistsFINAL")

user_artists_centrality <- merge(user_artists, user_centrality, by.x="userID", by.y="userID")
by_artist <- group_by(user_artists_centrality, artistIDNEW)
X1 <- as.data.frame(summarise(by_artist, mean = mean(centrality)))

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

scores.all[,3:12] = scores.all[,3:12] > 0
scores.all[,3:12] = lapply(scores.all[,3:12],function(x){factor(x,levels=c("TRUE","FALSE"))})

scores.all = cbind(scores.all , predicted = predict(classifier, scores.all[,3:12]))








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
