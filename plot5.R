#-----------------------------------------------------------------------------------------------------
# PLOT5.R
#   How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City
#-----------------------------------------------------------------------------------------------------

library("lattice")
# Download if data file not exist
if (!file.exists("./exdata-data-NEI_data/summarySCC_PM25.rds")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                destfile="./exdata-data-NEI_data.zip", method="curl")
  unzip("./exdata-data-NEI_data.zip", exdir=".")
}

# Write directly to PNG file
png(file="plot5.png", width=800, height=480)

## Read rds files
# Uncomment these lines if it's first time you read data

# NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
# SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Prepare data
tmp1 <- NEI[NEI$SCC %in% SCC[grep("Mobile", SCC$EI.Sector), 1], ]
tmp2 <- tmp1[which(tmp1$fips == "24510"), ]
tmp3 <- SCC[, c(1, 4)]
tmp4 <- merge(tmp2, tmp3, by.x = "SCC", by.y = "SCC")[, c(4, 6, 7)]
tmp4 <- tmp4[which(tmp4$EI.Sector != "Mobile - Commercial Marine Vessels"), ]
tmp4 <- tmp4[which(tmp4$EI.Sector != "Mobile - Aircraft"), ]
# plotting
xyplot(Emissions ~ year | EI.Sector, tmp4, layout = c(4, 2), ylab = "Emissions", 
       xlab = "years", panel = function(x, y) {
         panel.xyplot(x, y)
         panel.lmline(x, y, lty = 1, col = "red")
         par.strip.text = list(cex = 0.8)
       }, as.table = T)

# Close graphic device
dev.off()