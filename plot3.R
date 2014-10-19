#-----------------------------------------------------------------------------------------------------
# PLOT3.R
#   Of the four types of sources indicated by the type (point, nonpoint, onroad) variable,
#     which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City
#     Which have seen increases in emissions from 1999-2008?
#     Use the ggplot2 plotting system to make plot
#-----------------------------------------------------------------------------------------------------

library("ggplot2")

# Download if data file not exist
if (!file.exists("./exdata-data-NEI_data/summarySCC_PM25.rds")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                destfile="./exdata-data-NEI_data.zip", method="curl")
  unzip("./exdata-data-NEI_data.zip", exdir=".")
}

# Write directly to PNG file
png(file="plot3.png", width=800, height=480)

## Read rds files
# Uncomment these lines if it's first time you read data

# NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

dtBaltimores <- NEI[which(NEI$fips == "24510"),]
g2 <- ggplot(dtBaltimores, aes(year, Emissions))
g2 + geom_point(aes(color=type), size = 10, alpha = 0.5) + facet_grid(. ~ type) +
  geom_smooth(color="black", linetype=1, size = 1.5, method = "lm", se = FALSE)

# Close graphic device
dev.off()
