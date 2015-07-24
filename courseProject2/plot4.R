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

# data related to coal combustion
coalData <- filter(SCC, grepl("coal", EI.Sector, ignore.case = TRUE))
# find related SCC
coalSCC <- unique(coalData$SCC)
# subset data from NEI
coalNEI <- filter(NEI, SCC %in% coalSCC)

totalCoalNEI <- aggregate(Emissions ~ year, data = coalNEI, sum)

# facets is more suitable with lm fit to see the trends
if(!dir.exists("figures")){
    dir.create("figures")    
}

p <- ggplot(totalCoalNEI, aes(x = year, y = Emissions))
p + geom_point(size = 5, shape = 19, color = "red") + 
    geom_smooth(method = "lm", se = FALSE, lwd = 2, color = "blue") +
    labs(title = expression(paste("PM"["2.5"], " emissions from coal combustion")),
         x = "Year",
         y = "Emissions (tons)")
ggsave(filename = "figures/plot4.png", width = 5, height = 3)

