#-------------------------------------------------------------------------------------
# PLOT2.R
#   Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
#     (fips == "24510") from 1999 to 2008? 
#     Use the base plotting system to make a plot answering this question
#-------------------------------------------------------------------------------------

# Download if data file not exist
if (!file.exists("./exdata-data-NEI_data/summarySCC_PM25.rds")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                destfile="./exdata-data-NEI_data.zip", method="curl")
  unzip("./exdata-data-NEI_data.zip", exdir=".")
}

# Write directly to PNG file
png(file="plot2.png", width=600, height=480)

## Read rds files

# Uncomment these lines if it's first time you read data
# NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

years <- c("1999", "2002", "2005", "2008")
baltimores <- vector()
for ( y in years){
  baltimores[y] <- sum(NEI$Emission[which(NEI$year == y & NEI$fips == "24510")], na.rm = TRUE)
}
# Base plot
barplot(baltimores, col = terrain.colors(2), 
        main = "Total PM_2.5 emissions in Baltimore city", xlab = "Year", ylab = "Tons")

# Close graphic device
dev.off()