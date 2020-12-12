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

## Read data from only the dates 1/2/2007 and 2/2/2007 (dd/mm/yyy)
data <- read.csv.sql("household_power_consumption.txt", 
                     "select * from file where Date = '1/2/2007' or Date = '2/2/2007' ", 
                     header = TRUE, sep=";")

## Combine date and time into new column, drop old Date and Time columns
data <- data %>%
  mutate(date_time = paste(Date, Time), 
         .keep = "unused", 
         .before = 1)

## Convert to datetime class
data$date_time <- strptime(data$date_time, format = "%d/%m/%Y %H:%M:%S")

## Open PNG graphics device, plot & save to a 480x480 pixel PNG file.
png("plot3.png", width = 480, height = 480)

## Plot date_time and sub_metering with empty content in graph
plot(data$date_time, data$Sub_metering_1, 
     type = "n", 
     xlab = "",
     ylab = "Energy sub metering")

## Plot 2: Add multiple variables and a legend, both color coded.
lines(data$date_time, data$Sub_metering_1)
lines(data$date_time, data$Sub_metering_2, col = "red")
lines(data$date_time, data$Sub_metering_3, col = "blue")
legend("topright", lty = 1, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"))

## Close graphics device
dev.off()