## plot2.R displays a line plot of Global Active Power in kilowatts vs. date-time
## The x axis is labeled with days of the week
## The y axis is labeled "Global Active Power (kilowatts)

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

png(filename = "./data/plot2.png", height = 480, width = 480)

## Plot abbreviated day of week on x axis and Global_active_power on y axis
## Label x axis day of week with abbreviated day of the week - Thu, Fri or Sat
## Label y axis "Global Active Power (kilowatts)"

plot(com_two_days_df$posixfmt_date_time, com_two_days_df$Global_active_power, 
     xlab = "", ylab = "Global Active Power (kilowatts)", type = "l")

## Close graphics device

dev.off()
