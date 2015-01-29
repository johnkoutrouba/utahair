if (!file.exists("~/utahair")){
        dir.create("~/utahair")
}

setwd("~/utahair")

getdatafile <- function(startyear = 1997, endyear = 2014){
        for (i in startyear:endyear){
                url <- paste("http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/daily_88101_", i, ".zip", sep = "")
                destfilename <- paste("airdata", i, ".zip", sep = "")
                download.file(url, destfile = destfilename)
                unzip(destfilename)
        }
}

readdata <- function(startyear = 1997, endyear = 2014){
        for (i in startyear:endyear){
                print(paste("Reading data for", i))
                df <- read.csv(paste("daily_88101_", i, ".csv", sep = ""), header = TRUE)
                if (exists("airdata")){
                        airdata <- rbind(airdata, df[df$State.Name == "Utah",])
                } else {
                        airdata <- df[df$State.Name == "Utah",]
                }
        }
        return(airdata)
}

getdatafile()
airdata <- readdata()

airdata$Date.Local <- as.Date(as.character(airdata$Date.Local), "%Y-%m-%d")

library(ggplot2)

slcair <- airdata[airdata$City.Name == "Salt Lake City",]

qplot(Date.Local, Arithmetic.Mean, data = slcair, geom = c("point", "smooth"), xlab = "Date", ylab = "PM2.5")
ggsave("slctrend.png")

qplot(factor(year(Date.Local)), Arithmetic.Mean, data = slcair, geom = "boxplot", xlab = "Date", ylab = "PM2.5")
ggsave("slcboxplot.png")
