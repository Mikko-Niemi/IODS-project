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
colnames(hd) <- c("Rank", "Country", "HDI", "Expected.Life", "Expected.Education", "Mean.Education", "GNI", "GNI_minus_HDI")
head(hd)

colnames(gii) <- c("Rank", "Country", "GII", "Maternal_mortality", "Adolescent_birth", "Woman_rep.Parliament", "Edu2.Female", "Edu2.Male", "Labour.Female", "Labour.Male")
head(gii)

# Create two new variables to "Gender Inequility":
library(dplyr)
gii <- mutate(gii, "edu2F/edu2M" = gii$Edu2.Female / gii$Edu2.Male)
gii <- mutate(gii, "labF/labM" = gii$Labour.Female / gii$Labour.Male)
head(gii)

# Join data by country:
human <- inner_join(hd, gii, by = "Country", suffix = c(".HDI", ".GII"))
dim(human)
head(human)

# Write table:
write.table(human, file = "Data/human.txt", sep="\t")



#-------------------------------------#
### WEEK 5 PART, updated 19.11.2020 ###
#-------------------------------------#

str(human)
names(human)
summary(human)

# Access the stringr package:
library(stringr)

# Remove the commas from GNI and mutate numeric GNI to dataframe 'human':
GNI_numeric <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric()
human <- mutate(human, "GNI" = GNI_numeric)

# Keep only the columns we will need:
human <- dplyr::select(human, one_of("Country", "Edu2.Female", "Labour.Female", "Expected.Education", "Expected.Life", "GNI", "Maternal_mortality", "Adolescent_birth", "Woman_rep.Parliament"))

# Filter out all rows with NA values:
human <- filter(human, complete.cases(human) == TRUE)

# Look at the last 10 observations of human:
tail(human, 10)

# Define the last index we want to keep, and choose everything except the last 7 observations:
last <- nrow(human) - 7
human <- human[1:last, ]

# Add countries as rownames:
rownames(human) <- human$Country

# Remove the Country variable
human <- dplyr::select(human, -Country)

# Look at the dimensions:
dim(human)

# Write table:
write.table(human, file = "Data/human.txt", sep="\t", row.names=TRUE)