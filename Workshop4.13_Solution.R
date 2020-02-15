
library(recommenderlab)
library(reshape2)

retail <- readRDS("retail.rds")

str(retail)

index = sample(2, nrow(retail), replace = TRUE, prob = c(0.3,0.7))
train = retail[index == 1,]
test = retail[index == 2,]
traing <- acast(train, CustomerID ~ Description, value.var = "Quantity")
class(traing)
R <- as.matrix(traing)
trainreal <- as(R, "realRatingMatrix")
trainreal
head(as(trainreal, "data.frame"))
testg <- acast(test, CustomerID ~ Description, value.var = Quantity)
class(testg)
S <- as.matrix(testg)
testreal <- as(S, "realRatingMatrix")
testreal

recommender <- Recommender(trainreal, method = 'POPULAR')
recommender


pred <- predict(recommender, newdata=trainreal[100], n=10)
class(pred)
pred@itemLabels[1:10]

