---
require(knitr)
library(R.utils)
library(dplyr)
library(stringr)

data <- read.csv("repdata-data-StormData.csv.bz2", header=TRUE, na.strings = "")

cache = TRUE

dim(data)

head(data)

length(unique(data$EVTYPE))

harmful_event_data <- filter(data, as.numeric(format(as.Date(as.character(data$BGN_DATE), "%m/%d/%Y %H:%M:%S"), "%Y")) >= 1996)

dim(harmful_event_data)


colnames(data)

data$p_DMGEXP <- 1
data$p_DMGEXP  [data$PROPDMGEXP == "K" | data$PROPDMGEXP == "k"] <- 1000
data$p_DMGEXP  [data$PROPDMGEXP == "M" | data$PROPDMGEXP == "m"] <- 1000000
data$p_DMGEXP  [data$PROPDMGEXP == "B" | data$PROPDMGEXP == "b"] <- 1000000000
data$p <- data$PROPDMG * data$p_DMGEXP

data$c_DMGEXP <- 1
data$c_DMGEXP [data$CROPDMGEXP == "K" | data$CROPDMGEXP == "k"] <-  1000
data$c_DMGEXP [data$CROPDMGEXP == "M" | data$CROPDMGEXP == "m"] <-  1000000
data$c_DMGEXP [data $CROPDMGEXP == "B" | data$CROPDMGEXP == "b"] <- 1000000000
data$c <- data$CROPDMG * data$c_DMGEXP

harmfulE <- aggregate(x = data[,c("FATALITIES", "INJURIES")], 
                      by = list(data$EVTYPE), FUN = "sum")
names(harmfulE) <- c("event", "fatalities", "injuries")
event1 <- head(harmfulE[order(-harmfulE$fatalities,harmfulE$injuries),"event"],1)

harmful_event <- data[data$EVTYPE == event1,]
harmful_event_state <- aggregate(x = harmful_event
                                 [,c("FATALITIES", "INJURIES")], by = list(harmful_event$STATE), FUN = "sum")
names(harmful_event_state) <- c("state", "fatalities", "injuries")
stormE <- aggregate(x = data[,c("p", "c")], by = list(data$EVTYPE), FUN = "sum")

stormE <- aggregate(x = data[,c("p", "c")], by = list(data$EVTYPE), FUN = "sum")
names(stormE) <- c("event", "propdam", "cropdam")
event2 <- head(stormE[order(-stormE$propdam, - stormE$cropdam),"event"],1)

se_event <- data[data$EVTYPE == event1,]
se_state <- aggregate(x = se_event[,c("p", "c")], by = list(se_event$STATE), 
                      FUN = "sum")
names(se_state) <- c("state", "propdam", "cropdam")
harmfulE <- head(harmfulE[order(-harmfulE$fatalities, - harmfulE$injuries),],10)

harmfulE$event <- as.factor(as.character(harmfulE$event))

plot(harmfulE$event 
     ,harmfulE$fatalities
     ,type = "b"
     ,main = "U.S. Events Most Harmful to Population Health"
     ,xlab = "Type of Severe Events"
     ,ylab = "Number of Fatalities")

harmfulE

as.character(event1)

head(harmful_event_state [order(-harmful_event_state $fatalities, harmful_event_state $injuries),],10)

stormE_most_harmful <- head(stormE[order(-stormE$propdam, -stormE$cropdam),],10)

stormE_most_harmful$event <- as.factor(as.character(stormE_most_harmful$event))

plot(stormE_most_harmful$event
     ,stormE_most_harmful$propdam / 1000000000
     ,type = "b"
     ,main = "Severe Events Most Harmful to U.S. Economy"
     ,xlab = "Type of Severe Events"
     ,ylab = "Property Damage (Billions)")

stormE_most_harmful

as.character(event2)

head(se_state[order(-se_state$propdam,-se_state$cropdam),],20)
