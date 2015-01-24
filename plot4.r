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
SRC <- readRDS("Source_Classification_Code.rds")

# Subsetting

subsetGrepCoal <- grep("coal",SRC$EI.Sector,value=TRUE,ignore.case=TRUE)

subsetSRC <- subset(SRC, SRC$EI.Sector %in% subsetGrepCoal, select=SCC)
subsetNEI <- subset(NEI, NEI$SCC %in% subsetSRC$SCC)

# Total emissions for subset
plotData <- aggregate(subsetNEI[c("Emissions")], list(year = subsetNEI$year), sum)

png('plot4.png', width=480, height=480)
p <- ggplot(plotData, aes(x=year, y=Emissions)) +
  geom_point(alpha=.3) +
  geom_smooth(alpha=.2, size=1) +
  ggtitle("Total PM 2.5 Coal Combustion Emissions")

print(p)

dev.off()