# plot3.R

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
png("plot3.png", width = 480, height = 480)
plot(data$DateTime, data$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering", xaxt="n")
lines(data$DateTime, data$Sub_metering_2, col = "red")
lines(data$DateTime, data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)

# Customize the x-axis to ensure all labels including one extra label after the last day are displayed
date_seq <- seq(min(data$DateTime), max(data$DateTime) + 86400, by = "days")  # Add an extra day (86400 seconds in a day)
axis.POSIXct(1, at = date_seq, format = "%a")

#Close Device
dev.off()