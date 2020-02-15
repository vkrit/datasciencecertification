library(odbc)
con <- dbConnect(odbc(),
                 #Driver = "Simba SQL Server ODBC Driver",
                 Driver = "ODBC Driver 17 for SQL Server",
                 Server = "veedb.database.windows.net",
                 Database = "datasciencedb",
                 UID = "veerasak",
                 PWD = rstudioapi::askForPassword("Database password"),
                 Port = 1433)

customer <- dbGetQuery(con, "SELECT * FROM SalesLT.Customer")
str(customer)
head(customer)

dbDisconnect(con)




