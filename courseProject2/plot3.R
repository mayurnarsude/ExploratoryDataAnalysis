# loading required packages
if (!require("pacman")) {
  install.packages("pacman")
}
pacman::p_load(lubridate, dplyr, ggplot2)

# download URL, downloaded file, and working directory names
file.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
f <- file.path("NEIdata.zip") 
dirName <- "NEIdata"

# we are going to work in NEIdata folder
if (!dir.exists(dirName)){
  download.file(file.url, destfile = f)
  unzip(f, exdir = dirName)
  unlink(f)         # do not clutter the folder 
}

# reading the data
NEI <- readRDS(file.path(dirName, "summarySCC_PM25.rds"))
SCC <- readRDS(file.path(dirName, "Source_Classification_Code.rds"))

# filter for Baltimore City
baltimoreData <- filter(NEI, fips == "24510")
baltimoreData <- aggregate(Emissions ~ year + type, data = baltimoreData, sum)

# facets is more suitable with lm fit to see the trends
if(!dir.exists("figures")){
    dir.create("figures")    
}
png("figures/plot3.png", width = 700, height = 480)
  qplot(year, Emissions, 
        data = baltimoreData, 
        facets = .~type, 
        geom = c("point", "smooth"), 
        method = "lm", 
        se = FALSE,
        main = expression(paste("PM"["2.5"], " emissions in the Baltimore City, Maryland")),
        xlab = "Year",
        ylab = "Emission (tons)"
        )
dev.off()
