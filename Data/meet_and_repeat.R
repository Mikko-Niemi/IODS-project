# Mikko Niemi
# 30.11.2020
# Wrangling two data sets for analysing longitudinal data: BPRS and RATS
# ----------------------------------------------------------------------

# Set working directory:
setwd("C:/Users/mikniemi/OneDrive - University of Helsinki/OpenDataScience/IODS/IODS-project/Data")

# # Access the necessary packages:
library(dplyr)
library(tidyr)

# ----------------------------------------------------------------------

# Read the BPRS (brief psychiatric rating scale) data:
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = T)

# Look at the (column) names of BPRS:
names(BPRS)

# Look at the structure of BPRS:
str(BPRS)

# Print out summaries of the variables:
summary(BPRS)

# This data contains weekly measures of 40 males assigned to two treatment groups (1 or 2).
# The data is used to evaluate patients suspected having schizophrenia.
# The lower index value (minimum 18), the less symptoms of schizophrenia present.

# Factor treatment & subject:
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5, 5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# Now the data exists in longitudinal form, as there is one row per every observation.

#----------------------------------------------------------------------

# Read the RATS data:
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = T)

# Look at the (column) names of RATS:
names(RATS)

# Look at the structure of RATS:
str(RATS)

# Print out summaries of the variables:
summary(RATS)

# In this data rats were divided into 3 groups having different diets.
# The weights were measured weekly in grams, and we are interested if diet effects to growth.

# Factor variables ID and Group:
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Convert data to long form
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3, 4))) 

# Glimpse the data
glimpse(RATSL)

# And now I have also the RATS data in longitudinal form, as there is one row per one observation.

#----------------------------------------------------------------------
# Nice work of wrangling - then let's write the data sets to files:

write.table(BPRSL, file = "BPRSL.txt", sep="\t", row.names=TRUE)
write.table(RATSL, file = "RATSL.txt", sep="\t", row.names=TRUE)

