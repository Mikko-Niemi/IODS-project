# Mikko Niemi
# 2.11.2020
# Wrangling a new data set and saving it as a txt-file


# Set working directory:
setwd("C:/Users/mikniemi/OneDrive - University of Helsinki/OpenDataScience/IODS/IODS-project")

# Read the data to an object called "lrn14":
lrn14 <- read.table("Data/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Dimensions:
dim(lrn14)

# Structure:
str(lrn14)

# Access to dplyr- library:
library(dplyr)

# Creating different vectors of questions related to deep, surface and strategic learning:
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06", "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# Select the columns related to deep learning and create column 'deep' by averaging:
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# Select the columns related to surface learning and create column 'surf' by averaging:
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# Select the columns related to strategic learning and create column 'stra' by averaging:
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# Choosing which columns will be keeped:
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# Select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# Change the name of "Age" to "age"
colnames(learning2014)[2] <- "age"

# Change the name of "Attitude" to "attitude"
colnames(learning2014)[3] <- "attitude"

# Change the name of "Points" to "points"
colnames(learning2014)[7] <- "points"

# Select rows where points is greater than zero
learning2014 <- filter(learning2014, points > 0)

# See the dimensions:
dim(learning2014)

# See the structure:
str(learning2014)

# See some first rows:
head(learning2014)

# Write out the analysis file:
write.table(learning2014, file = "Data/learning2014.txt", sep="\t")
