library(reshape2)
library(dplyr)
library(arules)
library(arulesViz)
library(plyr)

retail <- readRDS("retail.rds")

str(retail)
df = as.data.frame(retail)
class(df)
str(df)
df$CustomerID = as.factor(df$CustomerID)
df$InvoiceNo = as.factor(df$InvoiceNo)
df_itemList <- ddply(df,c("CustomerID","Date"), 
                     function(df1)paste(df1$Description, 
                                        collapse = ","))
df_itemList$CustomerID <- NULL
df_itemList$Date <- NULL

#Rename column headers for ease of use
colnames(df_itemList) <- c("itemList")
write.csv(df_itemList,"ItemList.csv", 
          quote = FALSE, 
          row.names = TRUE)

txn = read.transactions(file = "ItemList.csv", 
                        rm.duplicates = TRUE, 
                        format = "basket",
                        sep = ",",
                        cols = 1);

txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)
itemFrequencyPlot(txn, topN = 20)
rules <- apriori(txn, parameter=list(supp=0.005, conf=0.8))
options(digits = 2)
inspect(rules[1:5])

basket_rules <- sort(rules, by="lift", decreasing = TRUE)
basket_rules <- basket_rules[1:100]
plot(basket_rules)
plot(basket_rules, engine = "htmlwidget")
plot(basket_rules, 
     method = "grouped", 
     control = list(k = 5))
plot(basket_rules, 
     method="graph", 
     control=list(type="items"), engine = "htmlwidget")
plot(basket_rules, 
     method="paracoord",  
     control=list(alpha=.5, reorder=TRUE))
plot(basket_rules,
     measure=c("support","lift"),
     shading="confidence",interactive=T)

