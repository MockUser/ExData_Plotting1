## Requires
require(dplyr)

fileName <- "household_power_consumption.txt"

## Check the existance of the data file
if (!file.exists(fileName)) {    
    stop("Data file not found! - The file household_power_consumption.txt should be in the current directory")
}

## Read the whole data file (some waiting is needed)
data <- read.csv(fileName, sep=";", dec=".", header=TRUE, nrows=2075259, stringsAsFactors=FALSE)

## Extract only period of interest data excluding also data missing rows
## Another option was to first convert to date/time and then extract using other date/time filter function
dataCleaned <- filter(data, (Date=="1/2/2007" | Date=="2/2/2007") & Global_active_power != "?")

## Create the PNG file setting transparent background (size could be omitted the default is 480x480)
png(file="plot1.png", width = 480, height = 480, bg = "transparent")

## Plot the histogram converting values to numeric, chosing the red color, setting x axis label and setting the main title
hist(as.numeric(dataCleaned[,"Global_active_power"]), col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")

## Close the PNG device
dev.off()