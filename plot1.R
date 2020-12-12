## Create file
library(dplyr)
library(sqldf)

## Check of file exists
if(!file.exists("CourseProject1.zip")){
  filename <- "CourseProject1.zip"
}
## Check if archive exists
if(!file.exists(filename)){
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, filename)
}

## Check if data file exists
if(!file.exists("household_power_consumption.txt")){
  unzip(filename)
}

## Read data from only the dates 1/2/2007 and 2/2/2007 (dd/mm/yyyy)
data <- read.csv.sql("household_power_consumption.txt", 
                     "select * from file where Date = '1/2/2007' or Date = '2/2/2007' ", 
                     header = TRUE, sep=";")

## Open PNG graphics device, plot & save to a 480x480 pixel PNG file.
png("plot1.png", width = 480, height = 480)

## Plot histogram of Global_active_power variable
hist(data$Global_active_power, 
     col = "red", 
     main = "Global Active Power", 
     xlab = "Golbal Active Power (kilowatts)")

## Close graphics device
dev.off()
