# required library
#install.packages("ggplot2")
library(ggplot2) 

# Download data?
fileName <- 'dataset.zip'
if (!file.exists(fileName)) {
  print("Downloading data...")
  url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
  download.file(url, fileName, method = 'curl')
  unzip(fileName)
}

# Read Data 
NEI <- readRDS("summarySCC_PM25.rds")
SRC <- readRDS("Source_Classification_Code.rds")

# Subsetting
subsetGrepVehicle <- grep("vehicle",SRC$EI.Sector,value=TRUE,ignore.case=TRUE)

subsetBCLA <- subset(NEI, fips=='24510'|fips=='06037')

subsetSRC <- subset(SRC, SRC$EI.Sector %in% subsetGrepVehicle, select=SCC)
subsetNEI <- subset(subsetBCLA, subsetBCLA$SCC %in% subsetSRC$SCC)

# Total emissions for subset
plotData <- aggregate(subsetNEI[c("Emissions")], list(fips=subsetNEI$fips, year = subsetNEI$year), sum)

# Adding city name to the data
plotData$cityName <- rep(NA, nrow(plotData))
plotData[plotData$fips=='24510',][,"cityName"] <- "Baltimore City"
plotData[plotData$fips=='06037',][,"cityName"] <- "Los Angeles County"

png('plot6.png', width=480, height=480)
p <- ggplot(plotData, aes(x=year, y=Emissions, colour=cityName)) +
  geom_point(alpha=.3) +
  geom_smooth(alpha=.2, size=1, method="loess") +
  ggtitle("Baltimore City and Los Angeles County \nVehicle Combustion Emissions")

print(p)

dev.off()