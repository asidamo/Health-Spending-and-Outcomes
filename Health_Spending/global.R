
rm(list=ls())
memory.size(max=F)

library(ggplot2)
library(shiny)
library(shinydashboard)
library(plotly)

# read data for national health expenditure per capita.
healthExp<-readRDS('./data/healthExp.RDS')

# read data for health spending categories

HealthExpCat<-readRDS('./data/HealthExpCategories.RDS')
HECcountries<-as.data.frame(HealthExpCat)

HECcountries<-HECcountries%>%
  select(country)%>%
  unique()

HECcountries<-sort(HECcountries$country)

# data for HealthResources 

HealthResources<-readRDS('./data/HealthResources')


hresourcevars<-as.data.frame(HealthResources)

hresourcevars<-hresourcevars%>%
  select(var)%>%
  unique()

hresourcevars<-sort(hresourcevars$var)


# read data for health care utilization
utilization<-readRDS('./data/utilization')

utilYears<-as.data.frame(utilization)

utilYears<-utilYears%>%
  select(Year)%>%
  unique()

utilYears<-sort(utilYears$Year)



utilmeasures<-as.data.frame(utilization)

utilmeasures<-utilmeasures%>%
  select(Measure)%>%
  unique()

utilmeasures<-sort(utilmeasures$Measure)


# read health care quality data
healthcareQI<-readRDS('./data/healthcareQI')


# let's read charges hospitals

hospitalPrices<-readRDS('./data/hospitalPrices')

colnames(hospitalPrices)<-c("Country","AveragePricePerAppendectomy","AveragePricePerCaesareanSection","PricePerNormalDelivery","AveragePricePerMRI")

# let's read charge to cost ratio by States

ccr_df<-readRDS('./data/ccr_df')