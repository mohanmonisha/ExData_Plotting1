# plot4.R

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
png("plot4.png", width = 480, height = 480)

# Set up a 2x2 plotting layout
par(mfrow = c(2, 2))  

# Plot on row 1, column 1
plot(data$DateTime, data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power", xaxt = "n")
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 86400, by = "days"), format = "%a", las = 2)

# Plot on row 1, column 2
plot(data$DateTime, data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage", xaxt = "n")
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 86400, by = "days"), format = "%a", las = 2)

# Plot on row 2, column 1
plot(data$DateTime, data$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering", xaxt = "n")
lines(data$DateTime, data$Sub_metering_2, col = "red")
lines(data$DateTime, data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, bty = "n")
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 86400, by = "days"), format = "%a", las = 2)

# Plot on row 2, column 2
plot(data$DateTime, data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", xaxt = "n")
axis.POSIXct(1, at = seq(min(data$DateTime), max(data$DateTime) + 86400, by = "days"), format = "%a", las = 2)

# Close the device
dev.off()
