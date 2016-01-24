## Load package
require(data.table)

## Set path
path <- getwd()

## Download file from source and unzip it if it does not exist in the working directory
if (!file.exists("household_power_consumption.txt")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    tempFile <- "temp-hpc.zip"
    download.file(fileUrl, file.path(path, tempFile))
    unzip(file.path(path, tempFile))
    unlink(tempFile)
}

## Read data
rawDT <- fread("household_power_consumption.txt")

## Create data frame with needed subset and clean NAs if there is any
subDT <- as.data.frame(rawDT[Date %in% c("1/2/2007", "2/2/2007"),])
if (length(subDT[subDT == "?"]) > 0) {
    subDT[subDT == "?"] <- NA
} 

## Convert Date and Time columns into Date/Time class as a new variable
subDT$Timestamp <- strptime(paste(subDT$Date, subDT$Time), "%d/%m/%Y %H:%M:%S")

## Make graphics with four plots by setting parameter first
par(mfrow = c(2,2))

## Plot 1
plot(subDT$Timestamp, as.numeric(subDT$Global_active_power), 
     type ="l",
     xlab = "",
     ylab = "Global Active Power")

## Plot 2
plot(subDT$Timestamp, as.numeric(subDT$Voltage), 
     type ="l",
     xlab = "datetime",
     ylab = "Voltage",
     ylim = c(233, 247))

## Plot 3
plot(subDT$Timestamp, as.numeric(subDT$Sub_metering_1), 
     type ="l",
     xlab = "",
     ylab = "Energy sub metering")

lines(subDT$Timestamp, as.numeric(subDT$Sub_metering_2), col = "red")
lines(subDT$Timestamp, as.numeric(subDT$Sub_metering_3), col = "blue")

legend("topright",
       lty=1, col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Plot 4
plot(subDT$Timestamp, as.numeric(subDT$Global_reactive_power), 
     type ="l",
     xlab = "datetime",
     ylab = "Global_reactive_power")

## Create png
dev.copy(png, file = "plot4.png", width = 480, height = 480, units="px")
dev.off()