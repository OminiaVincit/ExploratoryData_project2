#-----------------------------------------------------------------------------------------------------
# PLOT6.R
#   Compare emissions from motor vehicle sources in Baltimore City with emissions from
#     motor vehicle sources in Los Angeles County, California (fips = "06037")
#     Which city has seen greater changes over time in motor vehicle emissions
#-----------------------------------------------------------------------------------------------------

library("ggplot2")

# Download if data file not exist
if (!file.exists("./exdata-data-NEI_data/summarySCC_PM25.rds")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                destfile="./exdata-data-NEI_data.zip", method="curl")
  unzip("./exdata-data-NEI_data.zip", exdir=".")
}

# Write directly to PNG file
png(file="plot6.png", width=600, height=480)

## Read rds files
# Uncomment these lines if it's first time you read data

# NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Prepare data
dt <- rbind(NEI[which(NEI$fips == "24510"), ], NEI[which(NEI$fips == "06037"), ])
dt$fips[which(dt$fips == "24510")] <- "Baltimore City"
dt$fips[which(dt$fips == "06037")] <- "Los Angeles County"
names(dt)[1] <- "Cities"
# plotting
g6 <- ggplot(dt, aes(x = year, y = Emissions, fill = Cities))
g6 + geom_bar(stat = "identity", position = position_dodge())

# Close graphic device
dev.off()

