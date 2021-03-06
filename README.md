Exploratory Data Analysis - Course Project 2
============================================

# Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National [Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

# Data

The data for this assignment are available from the course web site as a single zip file:

* [Data for Peer Assessment [29Mb]](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)

The zip file contains two files:

PM2.5 Emissions Data (`summarySCC_PM25.rds`): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.
````
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
````

* `fips`: A five-digit number (represented as a string) indicating the U.S. county
* `SCC`: The name of the source as indicated by a digit string (see source code classification table)
* `Pollutant`: A string indicating the pollutant
* `Emissions`: Amount of PM2.5 emitted, in tons
* `type`: The type of source (point, non-point, on-road, or non-road)
* `year`: The year of emissions recorded

Source Classification Code Table (`Source_Classification_Code.rds`): This table provides a mapping from the SCC digit strings int he Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source ???10100101??? is known as ???Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal???.

You can read each of the two files using the `readRDS()` function in R. For example, reading in each file can be done with the following code:

````
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
````

as long as each of those files is in your current working directory (check by calling `dir()` and see if those files are in the listing).

# Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999???2008. You may use any R package you want to support your analysis.

## Making and Submitting Plots

For each plot you should

* Construct the plot and save it to a PNG file.
* Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You should also include the code that creates the PNG file. Only include the code for a single plot (i.e. plot1.R should only include code for producing plot1.png)
* Upload the PNG file on the Assignment submission page
* Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.

In preparation we first ensure the data sets archive is downloaded and extracted.

We now load the NEI and SCC data frames from the .rds files.

```r
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
```

## Questions

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

### Question 1

Using the base plotting system, now we plot the total PM2.5 Emission from all sources,


```r
years <- c("1999", "2002", "2005", "2008")
totals <- vector()
for ( y in years){
  totals[y] <- sum(NEI$Emission[which(NEI$year == y)], na.rm = TRUE)
}
# Base plot
barplot(totals, col = rainbow(20, start = 0, end = 1), 
        main = "Total PM_2.5 emissions", xlab = "Year", ylab = "Tons")
```

![plot of chunk plot1](plot1.png) 
As we can see from the plot, total emissions have decreased in the US from 1999 to 2008.

### Question 2

```r
baltimores <- vector()
for ( y in years){
  baltimores[y] <- sum(NEI$Emission[which(NEI$year == y & NEI$fips == "24510")], na.rm = TRUE)
}
# Base plot
barplot(baltimores, col = terrain.colors(2), 
        main = "Total PM_2.5 emissions in Baltimore city", xlab = "Year", ylab = "Tons")
```
![plot of chunk plot2](plot2.png) 
Overall total emissions from PM2.5 have decreased in Baltimore City, Maryland from 1999 to 2008.

### Question 3

Using the ggplot2 plotting system,


```r
library(ggplot2)

dtBaltimores <- NEI[which(NEI$fips == "24510"),]
g2 <- ggplot(dtBaltimores, aes(year, Emissions))
g2 + geom_point(aes(color=type), size = 10, alpha = 0.5) + facet_grid(. ~type) + 
  geom_smooth(color="black", linetype=1, size = 1.5, method = "lm", se = FALSE) + 
  labs(x="year", y=expression("Total PM"[2.5]*"Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*"Emissions, Baltimore City 1999-2008 by Source Type"))
```

![plot of chunk plot3](plot3.png) 
The non-road, nonpoint, on-road source types have all seen decreased emissions overall from 1999-2008 in Baltimore City.


### Question 4

First we subset coal combustion source factors NEI data.


```r
dt1 <- NEI[NEI$SCC %in% SCC[grep("Coal", SCC$EI.Sector), 1], ]
dt2 <- SCC[, c(1,4)]
dtCoal <- merge(dt1, dt2, by.x="SCC", by.y="SCC")[, c(4,6,7)]
```

Then using ggplot2

```r
library(ggplot2)

g3 <- ggplot(dtCoal, aes(year, Emissions))
g3 + geom_point(aes(color = EI.Sector), size = 10, alpha = 0.5) + facet_grid(. ~ EI.Sector) +
  geom_smooth(color="black", linetype=1, size = 1.5, method = "lm", se = FALSE) +
  labs(x="year", y=expression("PM"[2.5]*"Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*"Emissions from coal combustion-related sources changed"))
```

![plot of chunk plot4](plot4.png) 

### Question 5

First we subset the motor vehicles.


```r
tmp1 <- NEI[NEI$SCC %in% SCC[grep("Mobile", SCC$EI.Sector), 1], ]
tmp2 <- tmp1[which(tmp1$fips == "24510"), ]
tmp3 <- SCC[, c(1, 4)]
tmp4 <- merge(tmp2, tmp3, by.x = "SCC", by.y = "SCC")[, c(4, 6, 7)]
tmp4 <- tmp4[which(tmp4$EI.Sector != "Mobile - Commercial Marine Vessels"), ]
tmp4 <- tmp4[which(tmp4$EI.Sector != "Mobile - Aircraft"), ]
```
Then we plot using ggplot2,


```r
library("lattice")

xyplot(Emissions ~ year | EI.Sector, tmp4, layout = c(4, 2), ylab = "Emissions", 
       xlab = "years", panel = function(x, y) {
         panel.xyplot(x, y)
         panel.lmline(x, y, lty = 1, col = "red")
         par.strip.text = list(cex = 0.8)
       }, as.table = T)
```

![plot of chunk plot5](plot5.png) 

### Question 6

Comparing emissions from motor vehicle sources in Baltimore City (fips == "24510") with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"),


```r
dt <- rbind(NEI[which(NEI$fips == "24510"), ], NEI[which(NEI$fips == "06037"), ])
dt$fips[which(dt$fips == "24510")] <- "Baltimore City"
dt$fips[which(dt$fips == "06037")] <- "Los Angeles County"
names(dt)[1] <- "Cities"
```

Now we plot using the ggplot2 system,


```r
g6 <- ggplot(dt, aes(x = year, y = Emissions, fill = Cities))
g6 + geom_bar(stat = "identity", position = position_dodge())
```

![plot of chunk plot6](plot6.png)

### Use knit to export md file
```r
knit("README.Rmd", output="README.md", encoding="ISO8859-1", quiet=TRUE)
```
