# loading required packages
if (!require("pacman")) {
  install.packages("pacman")
}
pacman::p_load(lubridate, dplyr)

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
baltimore_emissions_by_year <- aggregate(Emissions ~ year, data = baltimoreData, sum)

# point plot with lm fit is more suitable
if(!dir.exists("figures")){
    dir.create("figures")    
}
png("figures/plot2.png", width = 480, height = 480, bg = "transparent")
with(baltimore_emissions_by_year, 
     plot(year, Emissions,
          type = "p",
          pch = 15,
          cex = 2,
          col = "red",
          xlab = "Year",
          ylab = "Total Emissions (tons)",
          main = expression(paste("PM"["2.5"], " emissions in the Baltimore City, Maryland")),
     )
)
fit1 <- lm(Emissions ~ year, data = baltimore_emissions_by_year)
abline(fit1, lty = "dashed", lwd = 2)
dev.off()
