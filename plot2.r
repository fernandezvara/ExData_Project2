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
plotData <- aggregate(subsetNEI[c("Emissions")], list(year = subsetNEI$year), sum)

# Plot 2
png('plot2.png', width=480, height=480)
plot(plotData$year, plotData$Emissions, type = "l", 
     main = "Total Emissions from PM2.5 in Baltimore City (1999 to 2008)",
     xlab = "Year", ylab = "Emissions")

dev.off()
