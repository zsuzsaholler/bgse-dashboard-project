setwd("~/Desktop/BGSE/DataWarehousing_BusinessIntelligence/Project")

user.friends <- read.table("user_friends.dat", header=TRUE, stringsAsFactors= FALSE, sep="\t")
head(user.friends)
dim(user.friends)
