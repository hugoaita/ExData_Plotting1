Sys.setlocale("LC_TIME", "C") # I include this line because my locale is Spanish and 
                              # instead of Thu, Fri, Sat I get Jue, Vie, Sab

filename <- "getdata_dataset.zip"
if(!file.exists(filename)) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, filename, method = "curl")
  unzip("getdata_dataset.zip")
}

data <- read.table("household_power_consumption.txt", sep=";",header=TRUE, nrows=1)
data$Date <- as.Date(data$Date, "%d/%m/%Y")

t0 <- as.POSIXct("16/12/2006 17:24:00", format="%d/%m/%Y %H:%M:%S")  
t1 <- as.POSIXct("01/02/2007 00:00:00", format="%d/%m/%Y %H:%M:%S")
t2 <- as.POSIXct("02/02/2007 23:59:00", format="%d/%m/%Y %H:%M:%S")  

min1 <- difftime(t1, t0, units="mins") + 1
min2 <- difftime(t2, t0, units="mins") + 1

header <- read.table('household_power_consumption.txt', nrows=1,
                     header=FALSE, sep=";", stringsAsFactors = FALSE)
data <- read.table("household_power_consumption.txt", sep=";",
                   header=FALSE, skip=min1, nrows=min2 - min1 + 1)
colnames(data) <- unlist(header)

data$Date <- as.Date(data$Date, format="%d/%m/%Y")
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))
data$Global_reactive_power <- as.numeric(as.character(data$Global_reactive_power))
data$Voltage <- as.numeric(as.character(data$Voltage))


data <- transform(data, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

data$Sub_metering_1 <- as.numeric(as.character(data$Sub_metering_1))
data$Sub_metering_2 <- as.numeric(as.character(data$Sub_metering_2))
data$Sub_metering_3 <- as.numeric(as.character(data$Sub_metering_3))


png(file="plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))
plot(data$timestamp, data$Global_active_power, type="l", xlab="", 
     ylab="Global Active Power")
plot(data$timestamp, data$Voltage, type="l", xlab="datetime", ylab="Voltage")

plot(data$timestamp, data$Sub_metering_1, type="l", xlab="", ylab="Energy submetering")
lines(data$timestamp, data$Sub_metering_2, col="red")
lines(data$timestamp, data$Sub_metering_3, col="blue")
legend("topright", lty=1, lwd=1, bty="n", col=c("black", "red","blue"), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       cex=0.6)

plot(data$timestamp, data$Global_reactive_power, type="l", xlab="datetime", 
     ylab="Global Reactive Power")


dev.off()


