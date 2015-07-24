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
motorData <- filter(SCC, grepl("vehicle", EI.Sector, ignore.case = TRUE))
# find related SCC
motorSCC <- unique(motorData$SCC)

# the friendly dplyr to subset and massage the data
totalMotorNEI <- NEI %>% 
    filter(SCC %in% motorSCC & fips == "24510") %>%
    group_by(year) %>%
    summarize(totalEmissions = sum(Emissions))


# facets is more suitable with lm fit to see the trends
if(!dir.exists("figures")){
    dir.create("figures")    
}

p <- ggplot(totalMotorNEI, aes(x = year, y = totalEmissions))
p + geom_point(size = 5, shape = 19, color = "red") + 
    geom_smooth(method = "lm", se = FALSE, lwd = 2, color = "blue") +
    labs(title = expression(paste("PM"["2.5"], " emissions from Motor vehicle sources in Baltimore City")),
         x = "Year",
         y = "Emissions (tons)")
ggsave(filename = "figures/plot5.png", width = 8, height = 5)

