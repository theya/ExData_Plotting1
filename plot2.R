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

## Plot Global activity power versus the date
plot(subDT$Timestamp, as.numeric(subDT$Global_active_power), 
     type ="l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")

## Create png
dev.copy(png, file = "plot2.png", width = 480, height = 480, units="px")
dev.off()