## Load Libraries
list.of.packages <- c("data.table","plyr","dplyr","tibble","lubridate")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only = TRUE)

# DATA DOWNLOAD
# Create temporary file
temp <- tempfile()

# Download zip into temporary file
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              destfile = temp)

# Unzip the zip file
list.data <- unzip(temp)

# Unlink the temporary file
unlink(temp)

# DATA READ
# Read as datatable the data
power.data <- fread(list.data)

# Subset the data for 1/2/2007 and 2/2/2007
power.data.sub <- power.data[which(power.data$Date == "1/2/2007" | power.data$Date == "2/2/2007") , ]

# Replace missing values
power.data.sub[power.data.sub == "?"] <- NA

# Add a clean date-time column
power.data.sub$DateTime <- dmy_hms(paste(power.data.sub$Date,power.data.sub$Time, sep=" "))

# Convert measurements from character to numeric
power.data.sub[, 3:8] <- sapply(power.data.sub[, c(3:8)], as.numeric, simplify = FALSE)

## PLOT 2

png(filename = "plot2.png", width = 480, height = 480)
plot(power.data.sub$DateTime, power.data.sub$Global_active_power,
     type = "l",
     ylab="Global Active Power (kilowatts)", xlab="", 
     main = "")
dev.off()