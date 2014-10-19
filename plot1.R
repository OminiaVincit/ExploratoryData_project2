#-------------------------------------------------------------------------------------
# PLOT1.R
#   Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#   Using the base plotting system, make a plot showing the total PM2.5 emission 
#     from all sources for each of the years 1999, 2002, 2005, and 2008.
#-------------------------------------------------------------------------------------

# Download if data file not exist
if (!file.exists("./exdata-data-NEI_data/summarySCC_PM25.rds")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                destfile="./exdata-data-NEI_data.zip", method="curl")
  unzip("./exdata-data-NEI_data.zip", exdir=".")
}

# Write directly to PNG file
png(file="plot1.png", width=600, height=480)

## Read rds files

# Uncomment these lines if it's first time you read data
# NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

years <- c("1999", "2002", "2005", "2008")
totals <- vector()
for ( y in years){
  totals[y] <- sum(NEI$Emission[which(NEI$year == y)], na.rm = TRUE)
}
# Base plot
barplot(totals, col = rainbow(20, start = 0, end = 1), 
        main = "Total PM_2.5 emissions", xlab = "Year", ylab = "Tons")

# Close graphic device
dev.off()