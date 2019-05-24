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

png(file="plot2.png", height=480, width=480)
# I add this row because if we run 'plot4.R' first, we will get a graph with
# four subplots
par(mfrow=c(1,1))
plot(data$Time, data$Global_active_power, type="l", xlab="", 
     ylab="Global Active Power (kilowatts)")
dev.off()

