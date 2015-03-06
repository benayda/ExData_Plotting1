## plot3.R plots Energy Sub_metering 1, 2, and 3 against date-time indicated by the day of the week
## The script also adds a legend indicating the color of the line for each Energy Sub_metering

## Read in a zip file and extracts the household_power_consumption text file
## Check to see if zip file has been downloaded
## If not, create the directory named data and download the zip file
## Unzip the zip file into the directory named data

if(!file.exists("./data/power.zip")) 
{
  dir.create("./data")
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL,destfile="./data/power.zip")
  unzip("./data/power.zip", exdir  = "./data")
}

## Read the household_power_consumption text file into the data frame, df
## Replace any question marks which indicate missing values with NA
## Fields in the household_power_consumption text file are separated by semi-colons

df <- read.csv("./data/household_power_consumption.txt", na.strings = "?", sep = ";")

## Concatenate date and time into one variable

df$date_time <- paste(as.character(df$Date), as.character(df$Time))

## Current format for date/time variable in data frame

fmt_date_time <- "%d/%m/%Y %H:%M:%S"

## Use POSIX format for start date/time and end date/time for range

df$posixfmt_date_time <- as.POSIXct(df$date_time, format=fmt_date_time)

first_date <- as.POSIXct("01/02/2007 00:00:00", format=fmt_date_time)

second_date <- as.POSIXct("02/02/2007 23:59:00", format=fmt_date_time)

## Create new data frame with data from just the days between the start date/time and end date/time

two_days_df <- df[df$posixfmt_date_time >= first_date & df$posixfmt_date_time <= second_date , ]

## Don't include rows with NAs in new data frame

com_two_days_df <- two_days_df [complete.cases(two_days_df),]

## Open graphics device and save plot to .png file

png(filename = "./data/plot3.png", height = 480, width = 480)

## Plot date-time on x axis and Energy sub metering (1,2, and 3) on y axis
## Label x axis with abbreviated day of the week - Thu, Fri or Sat
## Label y axis "Energy sub metering"
## Upper right box shows legend with color of line for each sub_meter

## Plot Sub_metering_1 with black lines

plot(com_two_days_df$posixfmt_date_time, com_two_days_df$Sub_metering_1, 
     xlab = "", ylab = "Energy sub metering", type = "l", col = "black")

## Plot Sub_metering_2 with red lines

lines(com_two_days_df$posixfmt_date_time, com_two_days_df$Sub_metering_2, type = "l", col = "red")

## Plot Sub_metering_3 with blue lines

lines(com_two_days_df$posixfmt_date_time, com_two_days_df$Sub_metering_3, type = "l", col = "blue")

## Add legend in the top right corner with different line colors 

legend("topright", lty=1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Close graphics device

dev.off()
