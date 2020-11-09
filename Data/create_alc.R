# Mikko Niemi
# 9.11.2020
# Wrangling a data set that describes student's performance in Math and Portuguese towards their alcohol consumption.

# Reference: P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7
# Available at https://archive.ics.uci.edu/ml/datasets/Student+Performance


# Set working directory:
setwd("C:/Users/mikniemi/OneDrive - University of Helsinki/OpenDataScience/IODS/IODS-project")

# Access to necessary libraries:
library(dplyr); library(ggplot2)

# Read and explore the data:
math <- read.csv("Data/student-mat.csv", sep = ";")
dim(math)
str(math)
head(math)

por <- read.csv("Data/student-por.csv", sep = ";")
dim(por)
str(por)
head(por)

# Join data by the selected identifiers:
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","guardian","traveltime","studytime","schoolsup","famsup","activities","nursery","higher","internet","romantic","famrel","freetime","goout","Dalc","Walc","health")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

# Explore the joined data:
dim(math_por)
str(math_por)
colnames(math_por)


# Create a new data frame with only the joined columns:
alc <- select(math_por, one_of(join_by))

# The columns which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]
notjoined_columns

# For every column name not used for joining...
for(column_name in notjoined_columns) {
  # Select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # Select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # If that first column vector is numeric...
  if(is.numeric(first_column)) {
    # Take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # Add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Glimpse at the new combined data
glimpse(alc)


# Define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# Glimpse at the latest data version
glimpse(alc)

# Finally, the data include 370 observations (rows) and 35 variables (columns)
dim(alc)

# Write out the table:
write.table(alc, file = "Data/alc.txt", sep="\t")

