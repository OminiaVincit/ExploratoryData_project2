#-----------------------------------------------------------------------------------------------------
# PLOT4.R
#   Across the United States, how have emissions from coal combustion-related sources changed
#-----------------------------------------------------------------------------------------------------

library("ggplot2")

# Download if data file not exist
if (!file.exists("./exdata-data-NEI_data/summarySCC_PM25.rds")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                destfile="./exdata-data-NEI_data.zip", method="curl")
  unzip("./exdata-data-NEI_data.zip", exdir=".")
}

# Write directly to PNG file
png(file="plot4.png", width=800, height=480)

## Read rds files
# Uncomment these lines if it's first time you read data

# NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Prepare data
dt1 <- NEI[NEI$SCC %in% SCC[grep("Coal", SCC$EI.Sector), 1], ]
dt2 <- SCC[, c(1,4)]
dtCoal <- merge(dt1, dt2, by.x="SCC", by.y="SCC")[, c(4,6,7)]
g3 <- ggplot(dtCoal, aes(year, Emissions))
g3 + geom_point(aes(color = EI.Sector), size = 10, alpha = 0.5) + facet_grid(. ~ EI.Sector) +
  geom_smooth(color="black", linetype=1, size = 1.5, method = "lm", se = FALSE)

# Close graphic device
dev.off()