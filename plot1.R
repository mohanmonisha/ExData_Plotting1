# plot1.R

# Load necessary libraries
library(data.table)

# Read the dataset
data <- fread("household_power_consumption.txt", na.strings = "?", sep = ";")

# Filter data for the required dates
data <- data[Date %in% c("1/2/2007", "2/2/2007")]

# Convert Date and Time columns to a single datetime column
data[, DateTime := as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")]

# Convert columns to numeric
cols_to_convert <- c("Global_active_power", "Global_reactive_power", "Voltage", 
                     "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
data[, (cols_to_convert) := lapply(.SD, as.numeric), .SDcols = cols_to_convert]

# Create the plot
png("plot1.png", width = 480, height = 480)
hist(data$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
dev.off()