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
png("plot4.png", width = 480, height = 480)

## Setting page layout for multiple graphs, will be drawn by columns
par(mfcol = c(2, 2))

## Plot 1: Global Active Power histogram
plot(data$date_time, data$Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")

## Plot 2: multivariable line graph
plot(data$date_time, data$Sub_metering_1, 
     type = "n", 
     xlab = "",
     ylab = "Energy sub metering")
lines(data$date_time, data$Sub_metering_1)
lines(data$date_time, data$Sub_metering_2, col = "red")
lines(data$date_time, data$Sub_metering_3, col = "blue")
legend("topright", lwd = 1, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"))

## Plot 3: datetime vs Voltage line graph
plot(data$date_time, data$Voltage, type = "l",
     xlab = "datetime",
     ylab = "Voltage")

## Plot 4: datetime vs Global Reactive Power line graph
plot(data$date_time, data$Global_reactive_power, type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power")

## Close graphics device
dev.off()