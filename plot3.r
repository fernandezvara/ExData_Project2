# required library
install.packages("ggplot2")
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

# Subsetting
subsetNEI <- subset(NEI, fips=='24510')

# Total emissions for subset
plotData <- aggregate(subsetNEI[c("Emissions")], list(type = subsetNEI$type, year = subsetNEI$year), sum)

png('plot3.png', width=480, height=480)
p <- ggplot(plotData, aes(x=year, y=Emissions, colour=type)) +
  geom_point(alpha=.3) +
  geom_smooth(alpha=.2, size=1, method="loess") +
  ggtitle("Total Emissions by Type in Baltimore City (1999-2008)")

print(p)

dev.off()