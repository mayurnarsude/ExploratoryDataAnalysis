
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

# create "Total emissions per year" dataframe
emissions_by_year <- aggregate(Emissions ~ year, data = NEI, sum)

# barplot is more suitable
if(!dir.exists("figures")){
    dir.create("figures")    
}
png("figures/plot1.png", width = 480, height = 480, bg = "transparent")
with(emissions_by_year, 
     barplot(Emissions,
             names.arg = as.character(year),
             col = "red",
             xlab = "Year",
             ylab = "Total Emissions (tons)",
             main = expression(paste("Total Emissions from ", "PM"["2.5"], " per Year")),
             ylim = c(0e+00, 8e+06)
             )
     )
dev.off()
