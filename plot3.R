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

## Convert Sub metering values data
subMetering1 <- as.numeric(as.character(dataCleaned$Sub_metering_1))
subMetering2 <- as.numeric(as.character(dataCleaned$Sub_metering_2))
subMetering3 <- as.numeric(as.character(dataCleaned$Sub_metering_3))

## Define a variables with the concatenated date/time string format
dataFormat <- "%d/%m/%Y %H:%M:%S"

## Convert the concatenated date/time data to POSIXlt using the defined format
datesTimesData <- strptime(paste(dataCleaned$Date, dataCleaned$Time), format=dataFormat)

## Set the locale based on the operating system (to get x axis in english)
if (.Platform$OS.type == "unix") {
    Sys.setlocale("LC_TIME", "en_US.UTF-8")
} else {
    Sys.setlocale("LC_TIME", "English")
}

## Create the PNG file setting transparent background (size could be omitted the default is 480x480)
png(file="plot3.png", width = 480, height = 480, bg = "transparent")

## Plot the submetering 1 graph setting the type to line, leaving the color to default black, setting the x axis label to empty and the y axis to the required label
plot(datesTimesData, subMetering1, type="l", lwd=1, xlab="", ylab="Energy sub metering")

## Plot the submetering 2 graph setting the type to line and the color to red
lines(datesTimesData, subMetering2, type="l", lwd=1, col="red")

## Plot the submetering 2 graph setting the type to line and the color to blue
lines(datesTimesData, subMetering3, type="l", lwd=1, col="blue")

## Add the legend to the graph with the three sub metering legends
legend("topright", lty=c(1,1), col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), xjust=1)

## Close the PNG device
dev.off()
