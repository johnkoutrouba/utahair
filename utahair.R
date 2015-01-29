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

hawthorneair <- airdata[airdata$Local.Site.Name == "Hawthorne",]

qplot(Date.Local, Arithmetic.Mean, data = slcair, geom = c("point", "smooth"), xlab = "Date", ylab = "PM2.5", main = "Salt Lake City PM2.5")

qplot(factor(year(Date.Local)), Arithmetic.Mean, data = slcair, geom = "boxplot", xlab = "Year", ylab = "PM2.5", main = "Salt Lake City PM2.5")

qplot(Date.Local, Arithmetic.Mean, data = airdata, colour = County.Name, geom = "smooth", se = FALSE)

qplot(Date.Local, Arithmetic.Mean, data = slcair, geom = "smooth", se = FALSE, xlab = "Date", ylab = "PM2.5", title = "Sale Lake City Trend")

qplot(Date.Local, Arithmetic.Mean, data = hawthorneair, geom = "smooth", se = FALSE, xlab = "Date", ylab = "PM2.5", title = "Sale Lake City Trend")

qplot(factor(month(Date.Local)), Arithmetic.Mean, data = hawthorneair, geom = "boxplot")

qplot(factor(County.Name), Arithmetic.Mean, data = airdata, geom = "boxplot")

