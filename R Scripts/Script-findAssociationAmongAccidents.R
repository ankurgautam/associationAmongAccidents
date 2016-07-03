#################### Association Rules Mining - Accidents ############


# Problem Statement
# The input dataset contains information about 1000 fatal accidents. It has different feature variables associated
# with the accident. The goal is to find patterns in the variables - which accident conditions frequently occur
# together.



##################### Data Engineering & Analysis ##############################

setwd("E:/Mission Machine Learning/Git/associationAmongAccidents")

accident_data <- read.csv("Data/accidents.csv")
str(accident_data)

summary(accident_data)

head(accident_data)

# Data Transformation The data frame needs to be converted into a Basket form to be loaded by the
# arules dataset. The following custom code does it.


#get column names of the data set
colnames <- names(accident_data)
#Start building a file in basket format - one row per transaction and each column value becoming
# a basket item in the format <column_name>=<column_value>
basket_str <- ""
for ( row in 1:nrow(accident_data)) {
  if ( row != 1) {
    basket_str <- paste0(basket_str, "\n")
  }
  basket_str <- paste0(basket_str, row,",")
  for (col in 2:length(colnames)) {
    if ( col != 2) {
      basket_str <- paste0(basket_str, ",")
    }
    basket_str <- paste0(basket_str, colnames[col],"=",accident_data[row,col])
  }
}
write(basket_str,"accidents_basket.csv")

# Exploratory Data Analysis
# Typically, for Clustering problems, EDA is only required for finding out
# outliers and errors. If outliers are found, we would want to eliminate them since they might skew the clusters
# formed by moving the centeroids signficantly.
install.packages("arules")
library(arules)

accidents <- read.transactions("accidents_basket.csv",sep=",")
summary(accidents)

itemFrequencyPlot(accidents,topN=10,type="absolute",
                  col="darkgreen", horiz=TRUE)


############################## Modeling & Prediction ###################################
#We discover the frequently occuring patterns with arules.
rules <- apriori(accidents, parameter=list(supp=0.1, conf=0.3))

inspect(rules[1:40])

