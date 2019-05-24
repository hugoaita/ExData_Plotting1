Sys.setlocale("LC_TIME", "C") # I include this line because my locale is Spanish and 
                              # instead of Thu, Fri, Sat I get Jue, Vie, Sab
filename <- "getdata_dataset.zip"
if(!file.exists(filename)) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, filename, method = "curl")
  unzip("getdata_dataset.zip")
}

# Read to get headers
initial <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", nrows=5)
# 2900 is not exactly the number of rows, we will subset them later
data <- read.table("household_power_consumption.txt", header=TRUE, sep=";",
                   skip=66630, nrows=2900, col.names=names(initial), na.strings=c("?"),
                   colClasses = c("character", "character", "numeric", "numeric", "numeric",
                                  "numeric", "numeric", "numeric", "numeric"))

# Convert Date & Time variables to Date/Time
data$Date <- as.Date(data$Date, format="%d/%m/%Y")
data$Time <- strptime(paste(data$Date, data$Time), "%F %T")

# Subset the correct number of rows
data <- subset(data, data$Date %in% as.Date(c("2007-02-01", "2007-02-02")))


png(file="plot3.png", width=480, height=480)
par(mfrow=c(1,1))
plot(data$Time, data$Sub_metering_1, type="n", xlab="", 
     ylab="Energy sub metering")
with(data, points(Time, Sub_metering_1, col="black", type="l"))
with(data, points(Time, Sub_metering_2, col="red", type="l"))
with(data, points(Time, Sub_metering_3, col="blue", type="l"))
legend("topright", lty=1, lwd=1, col=c("black", "red","blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()

