## Requires
require(dplyr)
require(lubridate)

fileName <- "household_power_consumption.txt"

## Check the existance of the data file
if (!file.exists(fileName)) {    
    stop("Data file not found! - The file household_power_consumption.txt should be in the current directory")
}

## Read the whole data file (some waiting is needed)
data <- read.csv(fileName, sep=";", dec=".", header=TRUE)

## Extract only period of interest data excluding also data missing rows
## Another option was to first convert to date/time and then extract using other date/time filter function
dataCleaned <- filter(data, (Date=="1/2/2007" | Date=="2/2/2007") & Global_active_power != "?")

## Create the PNG file setting transparent background (size could be omitted the default is 480x480)
png(file="plot4.png", width = 480, height = 480, bg = "transparent")

## Define the pictures for each row and each column
par(mfrow = c(2, 2))

## Set the locale based on the operating system (to get x axis in english)
if (.Platform$OS.type == "unix") {
    Sys.setlocale("LC_TIME", "en_US.UTF-8")
} else {
    Sys.setlocale("LC_TIME", "English")
}

################ Graph 1 - row 1/col 1 ################
## Convert values data
valuesData <- as.numeric(as.character(dataCleaned$Global_active_power))

## Define a variables with the concatenated date/time string format
dataFormat <- "%d/%m/%Y %H:%M:%S"

## Convert the concatenated date/time data to POSIXlt using the defined format
datesTimesData <- strptime(paste(dataCleaned$Date, dataCleaned$Time), format=dataFormat)

## Plot the graph setting the type to line, the x axis label to empty and the y axis to the required label
plot(datesTimesData, valuesData, type="l", lwd=1, xlab="", ylab="Global Active Power")

################ Graph 2 - row 1/col 2 ###############
## Plot the Voltage graph setting the type to line, leaving the color to default black, setting the x and axes labels to required values
plot(datesTimesData, as.numeric(as.character(dataCleaned$Voltage)), type="l", lwd=1, xlab="datetime", ylab="Voltage")

################ Graph 3 - row 2/col 1 ################
## Convert Sub metering values data
subMetering1 <- as.numeric(as.character(dataCleaned$Sub_metering_1))
subMetering2 <- as.numeric(as.character(dataCleaned$Sub_metering_2))
subMetering3 <- as.numeric(as.character(dataCleaned$Sub_metering_3))

## Define a variables with the concatenated date/time string format
dataFormat <- "%d/%m/%Y %H:%M:%S"

## Convert the concatenated date/time data to POSIXlt using the defined format
datesTimesData <- strptime(paste(dataCleaned$Date, dataCleaned$Time), format=dataFormat)

## Plot the submetering 1 graph setting the type to line, leaving the color to default black, setting the x axis label to empty and the y axis to the required label
plot(datesTimesData, subMetering1, type="l", lwd=1, xlab="", ylab="Energy sub metering")

## Plot the submetering 2 graph setting the type to line and the color to red
lines(datesTimesData, subMetering2, type="l", lwd=1, col="red")

## Plot the submetering 2 graph setting the type to line and the color to blue
lines(datesTimesData, subMetering3, type="l", lwd=1, col="blue")

## Add the legend to the graph with the three sub metering legends and without the border
legend("topright", lty=c(1,1), col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), xjust=1, bty="n")

################ Graph 4 - row 2/col 2 ################
## Plot the Global reactive power graph setting the type to line, leaving the color to default black, setting the x and axes labels to required values
plot(datesTimesData, as.numeric(as.character(dataCleaned$Global_reactive_power)), type="l", lwd=1, xlab="datetime", ylab="Global_reactive_power")

## Close the PNG device
dev.off()
