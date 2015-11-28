library("stringr")
library(e1071)

#Loading in full tag table
setwd("/home/zsuzsa/Documents/project/bgse-dashboard-project/working/")
tags <- read.table("/home/zsuzsa/Documents/project/data/tags.dat", header=TRUE, sep= "\t", stringsAsFactors=FALSE, quote = "")
#Loading in tag sample with sentiments assigned
tags.classified = read.csv("sample.csv", header=TRUE, stringsAsFactors=FALSE, quote = "")
names(tags.classified)[3] = "sentiment"
tags.classified[3] = as.factor(tags.classified[,3])


#sample = sample(unlist(tags[,1]),300)
#sample = tags[tags$tagID %in% sample,]
#write.csv( sample , file = "sample.txt", row.names = F)

#negative <- read.table("negative-words.txt"
#                       , header=FALSE, sep= "\t", stringsAsFactors=FALSE,  quote = "", skip=35)

#positive <- read.table("positive-words.txt"
#                       , header=FALSE, sep= "\t", stringsAsFactors=FALSE,  quote = "", skip=35)


#Loading in word list for classification
afin_list <- read.delim(file="AFINN-111.txt", header=FALSE, stringsAsFactors=FALSE)
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

scores.classification[,14] = (-5)*scores.classification[,4] + (-4)*scores.classification[,5] + (-3)*scores.classification[,6] +
  (-2)*scores.classification[,7] + (-1)*scores.classification[,8] + (1)*scores.classification[,9] + (2)*scores.classification[,10] +
  + (3)*scores.classification[,11] + (4)*scores.classification[,12] + (5)*scores.classification[,13]

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
scores.all = cbind(scores.all , predicted = predict(classifier, scores.all[,3:12]))



