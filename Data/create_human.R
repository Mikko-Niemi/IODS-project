# Mikko Niemi
# 16.11.2020
# Wrangling and joining two data sets: "Human development" and "Gender inequality" 
# --------------------------------------------------------------------------------

# Set working directory:
setwd("C:/Users/mikniemi/OneDrive - University of Helsinki/OpenDataScience/IODS/IODS-project")

# Read a data "Human development":
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# Read a data "Gender inequality":
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Explore the data sets:
str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

# Rename the columns:
colnames(hd) <- c("Rank", "Country", "HDI-index", "Expected.Life", "Expected.Education", "Mean.Education", "GNI-index", "GNI.Rank-HDI.Rank")
head(hd)

colnames(gii) <- c("Rank", "Country", "GII-index", "Maternal_mortality", "Adolescent_birth", "Woman_rep.Parliament", "Edu2.Female", "Edu2.Male", "Labour.Female", "Labour.Male")
head(gii)

# Create two new variables to "Gender Inequility":
library(dplyr)
gii <- mutate(gii, "edu2F/edu2M" = gii$Edu2.Female / gii$Edu2.Male)
gii <- mutate(gii, "labF/labM" = gii$Labour.Female / gii$Labour.Male)
head(gii)

# Join data by country:
human <- inner_join(hd, gii, by = "Country", suffix = c(".hd", ".gii"))
dim(human)
head(human)

# Write table:
write.table(human, file = "Data/human.txt", sep="\t")
