library(dplyr)

if (!file.exists("./data")){
        dir.create("./data")
}

# Download, record date of dowload and unzip the datasets
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, dest="./data/household_power_consumption.zip", mode="wb")

# Record date of download
dateDowloaded <- date()
# dateDowloaded = "Wed Dec 21 18:46:41 2016"

# Unzip the dataset and read the total data
unzip ("./data/household_power_consumption.zip", exdir = "./data")
totalData <- read.table("./data/household_power_consumption.txt", header = TRUE, sep = ";",
                        stringsAsFactors = FALSE, na.strings = "?" )

# To prevent Dutch week day names.
Sys.setlocale("LC_TIME", "English")

totalData$Date <- as.Date(totalData$Date, format="%d/%m/%Y")

#Select the required rows
neededData <- subset(totalData, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))

# Remove totalData from memory
rm(totalData)

## Make one column both date and time
neededData$Datetime <- as.POSIXct(paste(as.Date(neededData$Date), neededData$Time))

neededData <- tbl_df(neededData)

neededData <- select(neededData, Datetime, Date:Sub_metering_3)

# Create plot3

# With copy the legend does not look right
png("plot3.png", width = 480, height = 480)

with(neededData, {
     plot(Sub_metering_1 ~ Datetime, col = "black", type = "l", ylab = "Energy sub metering", xlab = "")
     lines(Sub_metering_2 ~ Datetime, col = "red")
     lines(Sub_metering_3 ~ Datetime, col = "blue")
})

legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Save to png file
dev.off()
