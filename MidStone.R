
rm(list=ls())
memory.size(max=F)
setwd("C:\\Users\\fevty\\Desktop\\NSS\\Health-Spending-and-Outcomes\\Archive")
library(tidyverse)
library(ggplot2)
library(tidyr)
library(magrittr)
library(dplyr)
library(broom)
library(rmarkdown)
library(knitr)
# Install packes geojsonio and geojsonR 
library(geojsonio)
library(geojsonR)
library(leaflet)
library(spdplyr)
library(readxl)




# read file

# Import heath expenditure per capita data for OECD
healthExp<- read.csv("DP_LIVE_22122018214748365.csv",stringsAsFactors = TRUE)
head(healthExp)

# rename columns
colnames(healthExp)<-c("country" ,"indicator" ,  "subject"  ,   "measure"   ,  "frequency" ,  "year"   ,     "percapitaHealthExp", "Flag.Codes")

# create OECD average column data
healthExp<- healthExp%>%
  group_by(year)%>%
  (OECDAverage=mean(percapitaHealthExp))

saveRDS(healthExp,'healthExp.RDS')

# plot USA per capita health expenditure and OECD average

healthExp%>%
  filter(country=="USA")%>%
    ggplot(aes(x=year,y=percapitaHealthExp))+
  geom_line(color='red',size=2)+
  geom_line(aes(y=OECDAverage),color='blue',size=2)+
ggtitle('Per Capita Health Expenditure USA vs OECD Average Trend')+
theme(plot.title = element_text(face='bold',hjust = 0.5))

# find top five countries in terms of per capita health spending.

highNHE<-healthExp[order(healthExp$percapitaHealthExp,decreasing = TRUE),]%>%
  filter(year==2016)%>%
  select(country,percapitaHealthExp)%>%
  top_n(5)

# get vector for top health spending countries. 
highNHE<-highNHE$country

# create top 5 countries data frame
healthExp_top5<-healthExp%>%
               filter(country %in% highNHE )
  

# keep only required columns  to use later.
healthExp_select<-data.frame(healthExp$year,healthExp$country,healthExp$percapitaHealthExp)
head(healthExp_select)

# rename the columns 
colnames(healthExp_select)<-c('year','country','percapitaHealthExp')

# in order to consider Canada for comparison with USA, add it in the filter becuase it is not
# among top 5 countries.
healthExp_select<-healthExp_select%>%
  filter(country %in% c('USA','CAN','DEU','SWE','NOR','AUS'))
head(healthExp_select)

# just check how many countries are in OECD
country<-as.data.frame(healthExp$country)
countries<-country%>%
  select('healthExp$country')%>%
  unique()
nrow(countries)
  
# let's import per capita health expenditure data by spending categories and by countries
# https://www.oecd-ilibrary.org/social-issues-migration-health/data/oecd-health-statistics/system-of-health-accounts-health-expenditure-by-function_data-00349-en 
HCareExp<-read.csv('SHA_24122018192846996.csv',stringsAsFactors = FALSE)

head(HCareExp)

# let's filter the dataset by Provider Type and Measure of Value
HCareExpAllProviders <- HCareExp %>% 
  filter(Financing.scheme=='All financing schemes',Provider=='All providers',Measure=='Share of current expenditure on health')

# keep only neccessary columns

HCareExpAllProviders<-data.frame(HCareExpAllProviders$Country,HCareExpAllProviders$Year,HCareExpAllProviders$HC,HCareExpAllProviders$Function,HCareExpAllProviders$Value)

# rename columns
colnames(HCareExpAllProviders)<-c('Country','year','HC','Function','healthExpValue')

head(HCareExpAllProviders)

# list of countries with highest National Health Spending in 2016
# add Canada as additional in the list besides top 6 countries in NHE
highNHE<-c('United States','Canada','Norway','Germany','Sweden','Australia')

# replace country with full country names
healthExp_select<-healthExp_select%>%
  mutate(Country=if_else(country=='USA','United States',NA_character_),
         Country=if_else(country=='CAN','Canada', Country),
         Country=if_else(country=='DEU', 'Germany', Country),
         Country=if_else(country=='SWE','Sweden',Country),
         Country=if_else(country=='NOR','Norway',Country),
         Country=if_else(country=='AUS','Australia',Country))
head(healthExp_select)

# plot per capita health spending 
healthExp_select%>%
  ggplot(aes(x=year,y=percapitaHealthExp,col=Country))+
  geom_line(size=2)+
  labs(title='Per Capita Health Expenditure USA vs OECD Countries Trend',x='year',y='PercapitaHealthExp')+
  theme(plot.title = element_text(face='bold',hjust = 0.5))

# keep only countries in highNHE list
data<-HCareExpAllProviders%>%
  filter(Country %in% highNHE)

# keep only required columns 
data<-data.frame(data$Country,data$year,data$HC,data$healthExpValue)
colnames(data)<-c('Country','year','HC','healthExpValue')


# filter curative care, preventive care and administration cost 
HcareExpCategories<-data%>%
  filter(HC %in% c('HC1HC2','HC6','HC5','HC7'))
# check data for Canada in year 2000 percentage of curative care spending.
HcareExpCategories%>%
  filter(year==2000, Country=='Canada',HC=='HC1HC2')

# spread health care categories and create columns for each categories
HcareExpCategories<-HcareExpCategories%>%
  spread(HC,healthExpValue)

#rename columns

colnames(HcareExpCategories)<-c('Country','year','CurativeRehabCare','Medicalgoods','PreventiveCare','Administrative')
head(HcareExpCategories)

# join health categories and healthExp_select dataframes

HcareExpCategories<-HcareExpCategories%>%
       inner_join(healthExp_select,by=c('Country','year'))

# keep only required columns
HcareExpCategories<-data.frame(HcareExpCategories$Country,HcareExpCategories$year,HcareExpCategories$CurativeRehabCare,
                               HcareExpCategories$Medicalgoods,HcareExpCategories$PreventiveCare,
                               HcareExpCategories$Administrative,
                               HcareExpCategories$percapitaHealthExp)
# rename columns

colnames(HcareExpCategories)<-c('country','year','CurativeRehabCare','Medicalgoods','PreventiveCare','Administrative','percapitaHealthExp')
head(HcareExpCategories)


head(HcareExpCategories)
# save as RDS file to use in shiny app.

saveRDS(HcareExpCategories,'HcareExpCategories.RDS')



# pharmaceutical Expenditure
# import pharmacuetical spending data
pharmaExp<-read.csv('PriceData//pharmaExpPerCapita.csv',stringsAsFactors = FALSE)
head(pharmaExp)

# reshape the data, remove X,from years, filters years since 2000 and selected countries
pharmaExp_df<-pharmaExp%>%
gather(Year,PerCapitaPharmaExp,X1970:X2016)%>%
mutate(Year=gsub('X',"",Year))%>%
  filter(Year>=2000,Country %in% c('United States','Canada','Norway','Germany','Sweden','Australia'))


head(pharmaExp_df)

# sort the data frame
pharmaExp_df<-pharmaExp_df[order(pharmaExp_df$PerCapitaPharmaExp,decreasing = FALSE),]
head(pharmaExp_df)

max(pharmaExp_df$PerCapitaPharmaExp)

# I have string values in PerCapitaPharmaExp column, I need to convert the column into numeric
# and asssing the column back to the Dataframe
pharmaExp_df$PerCapitaPharmaExp<-sapply(pharmaExp_df$PerCapitaPharmaExp,as.numeric)
pharmaExp_df$Year<-sapply(pharmaExp_df$Year,as.numeric)

# rename column names
colnames(pharmaExp_df)<-c('country','year','PerCapitaPharmaExp')

# merge HealthExpCategories with pharmaExp_df
HealthExpCategories<-HcareExpCategories%>%
  inner_join(pharmaExp_df,by=c('country','year'))

# convert country column to factor
HealthExpCategories$country<-sapply(HealthExpCategories$country,as.factor)

  # check class of PerCapitaPharmaExp column
class(HealthExpCategories$PerCapitaPharmaExp)
  
saveRDS(HealthExpCategories,'HealthExpCategories.RDS')


# Import health outcomes data

healthoutcomes<-read.csv('HEALTH_STAT_25122018044309188.csv',stringsAsFactors = FALSE)

head(healthoutcomes)
# Does USA has better health outcomes compared with OECD countries?

# check the unique variables listed
healthoutcomes%>%
  select(Variable)%>%
  unique()

# sort health outcomes by value

head(healthoutcomes)
healthoutcomes[order(healthoutcomes$Value,decreasing=TRUE),]%>%
  group_by(Country)%>%
  filter(Variable=='Diabetes mellitus',Year==2000)%>%
  top_n(5)

# heart diseases

head(healthoutcomes)
healthoutcomes[order(healthoutcomes$Value,decreasing=TRUE),]%>%
  group_by(Country)%>%
  filter(Variable=='Ischaemic heart diseases',Year==2015)%>%
  top_n(5)

# filter  health outcome indicators

healthoutcomes<-healthoutcomes%>%
              filter(Variable %in% c('Malignant neoplasms of Female breast',
                                     "Good/very good health, total aged 15+","Pneumonia",
                                     "Acute myocardial infarction","Ischaemic heart diseases","Drug use disorders",
                                     "Diabetes mellitus",
                                     "Infant mortality, Minimum threshold of 22 weeks (or 500 grams birthweight)","Total population at birth"))
# filter measures

healthoutcomes<-healthoutcomes%>%
               filter(Measure %in% c("% of population (crude rate)",'Deaths per 100 000 population (standardised rates)'
                                     ,'Deaths per 100 000 females (standardised rates)','Deaths per 1 000 live births','Years'))

saveRDS(healthoutcomes,"healthoutcomes")


# drug use disorder

head(healthoutcomes)
healthoutcomes[order(healthoutcomes$Value,decreasing=TRUE),]%>%
  group_by(Country)%>%
  filter(Variable=='Drug use disorders',Year==2015)%>%
  top_n(5)

# imporant link https://www.pbs.org/newshour/health/health-costs-how-the-us-compares-with-other-countries 

# import non medical determinants of health 

nonmedicalDet<-read.csv('HEALTH_LVNG_28122018020513354.csv',stringsAsFactors = FALSE)


# VARIABLES DEFINITIONS

#Total calories supply:FOODCALT
#Sugar supply:FOODSUCR
#Alcohol consumption:ACOLALCT
#Tobacco consumption:TOBATBCT
#Obese population, measured:BODYOBMS
#Obese population, self-reported:BODYOBSR
# top tobacco consuming countries in 2015

nonmedicalDet[order(nonmedicalDet$Value,decreasing=TRUE),]%>%
  group_by(Country)%>%
  filter(Variable=='Tobacco consumption',Year==2015)%>%
  top_n(5)

# Percentage Of obese population in total population 

nonmedicalDet[order(nonmedicalDet$Value,decreasing=TRUE),]%>%
  group_by(Country)%>%
  filter(Variable=='Obese population, self-reported',Year==2015)%>%
  top_n(5)

# Alcohol COnsumption 


nonmedicalDet[order(nonmedicalDet$Value,decreasing=TRUE),]%>%
  group_by(Country)%>%
  filter(Variable=='Alcohol consumption',Year==2015)%>%
  top_n(5)


# quality of health Inidcators 
# import  health quality indicator data.
healthcareQI<-read.csv('HEALTH_HCQI_27122018040707968.csv',stringsAsFactors = FALSE)

  
head(healthcareQI)

# filter periods and gender group

healthcareQI<-healthcareQI%>%
  filter(Periods%in% c(2016,2010-2014),Gender=='Total')

# check unique indicators
definitionIND<-healthcareQI%>%
  select(IND,Indicator)%>%
  unique()

# filter indicators
healthcareQI<-healthcareQI%>%
                  filter(IND %in% c('WAITGEAP','RHPTIPAT','COSKCOST','MTSKCOST','PMSKCOST'))


healthcareQI<-healthcareQI%>%
  filter(Value=="Age-sex standardised rate per 100 patients")
healthcareQI$Country<-sapply(healthcareQI$Country,as.factor)


healthcareQI<-healthcareQI%>%
  spread(IND,Value.1)

# keep required columns

healthcareQI<-data.frame(healthcareQI$Country,healthcareQI$Periods,healthcareQI$Indicator,healthcareQI$COSKCOST,
                         healthcareQI$MTSKCOST,healthcareQI$PMSKCOST,healthcareQI$RHPTIPAT,
                         healthcareQI$WAITGEAP,stringsAsFactors = FALSE)

# rename column names
colnames(healthcareQI)<-c("Country","Periods","Indicator","COSKCOST", "MTSKCOST","PMSKCOST","RHPTIPAT", "WAITGEAP")


saveRDS(healthcareQI,'healthcareQI')



healthcareQI%>%
  select(Indicator)%>%
    unique()

#healthcareQI<-healthcareQI%>%
  #filter( Indicator %in% c('Hypertension hospital admission',
                      #     'Diabetes hospital admission','Diabetic patients with prescription of first choice antihypertensive medication',
                       #   'Thirty-day mortality after admission to hospital for AMI based on admission data',
                       #    'Hip-fracture surgery initiated within the same day after admission to the hospital',
                        #   "Breast cancer five year relative survival",
                         #  "Consultation skipped due to costs",
                          #  "Medical tests, treatment or follow-up skipped due to costs",
                          # "Prescribed medicines skipped due to costs",
                          # "Waiting time of more than four weeks for getting an appointment with a specialist",
                          #  "Patients reporting having spent enough time with any doctor during the consultation",
                          # "Patients reporting having spent enough time with their regular doctor during the consultation"))

# countries included in healthcareQI

healthcareQI%>%
  select(Country)%>%
  unique()


# Import Health care Utilization data

utilization<-read.csv('HEALTH_PROC_29122018044021354.csv',stringsAsFactors = FALSE)

head(utilization)


utilization[order(utilization$Value,decreasing=TRUE),]%>%
   filter(Country=='United States',Year>=2010)%>%
    select(Variable)%>%
      unique()


utilization_df<-utilization%>%
  filter(Year>=2005)
   
utilization_df<-utilization_df%>%
  filter( Variable %in% c("Doctors consultations (in all settings)","Breast cancer screening, survey data",
                          "Curative care average length of stay","Magnetic Resonance Imaging exams, total","Caesarean section"))

utilization<-utilization_df%>%
                 filter(Measure %in% c('Number per capita','% of females aged 50-69 screened',
                                    'Days','Per 1 000 population',
                                       'Inpatient procedures per 1 000 live births'))




utilization<-utilization%>%
  mutate(var=if_else (Variable=='Doctors consultations (in all settings)','Doctorsconsultations',NA_character_),
         var= if_else (Variable=='Magnetic Resonance Imaging exams, total','MRIExams',var),
         var=if_else(Variable=='Breast cancer screening, survey data','BreastCancerScreening',var),
         var=if_else(Variable=='Caesarean section','CaesareanSection',var),
         var=if_else(Variable=='Curative care average length of stay','CurativeCareAverageLengthofStay',var))

utilization<-utilization%>%
drop_na(var)

saveRDS(utilization,'utilization_2')



#  replace country  value china to a shorter format.

#utilization$Country[which(utilization$Country=="China (People's Republic of)")]<-'China'

utilization$Country[utilization$Country=="China (People's Republic of)"]<-'China'

class(utilization$Measure)

utilization<-data.frame(utilization$Country,utilization$Year,utilization$Measure,utilization$BreastCancerScreening
                        ,utilization$CaesareanSection,utilization$CurativeCareAverageLengthofStay,utilization$Doctorsconsultations,
                        utilization$MRIExams,stringsAsFactors = FALSE)





colnames(utilization)<-c("Country","Year","Measure","BreastCancerScreening","CaesareanSection",
                         "CurativeCareAverageLengthofStay","Doctorsconsultations","MRIExams")
class(utilization$Measure)

saveRDS(utilization,'utilization')

utilizatioin[order(utilizatioin$Value,decreasing=TRUE),]%>%
  group_by(Variable)%>%
  filter(Country=='United States',Year==2015)%>%
  summarize(meanValue=mean(Value))
# 

lengthofStayCurativeCare<-utilizatioin[order(utilizatioin$Value,decreasing=TRUE),]%>%
  group_by(Country)%>%
  filter(Variable=='Curative care average length of stay',Year==2015)%>%
  summarize(meanValue=mean(Value))
# top 10 countries interms of curative stay in hospital
head(lengthofStayCurativeCare[order(lengthofStayCurativeCare$meanValue,decreasing = TRUE),],10)
# check USA curative hospital stay 
lengthofStayCurativeCare[order(lengthofStayCurativeCare$meanValue,decreasing = TRUE),]%>%
  filter(Country=='United States')

# Import health care resources data

hcResources<-read.csv('HEALTH_REAC_30122018014853533.csv',stringsAsFactors = FALSE)

head(hcResources)

HealthResources<-hcResources%>%
filter(Variable %in% c('Professionally active physicians','Total hospital beds','Magnetic Resonance Imaging units, total','Computed Tomography scanners, total'),Year==2015,
Measure %in% c('Density per 1 000 population (head counts)','Per million population','Per 1 000 population'))
 

HealthResources<-HealthResources%>%
  mutate(var=if_else (Variable=='Professionally active physicians','Active Physcians',NA_character_),
         var= if_else (Variable=='Total hospital beds','Hospital Beds',var),
         var=if_else(Variable=='Magnetic Resonance Imaging units, total','MRI',var),
         var= if_else (Variable=='Computed Tomography scanners, total','CT Scanners',var))

HealthResources$Country[HealthResources$Country=="China (People's Republic of)"]<-'China'

HealthResources<-data.frame(HealthResources$Country,HealthResources$Year,HealthResources$Variable,HealthResources$var,
                            HealthResources$Value,stringsAsFactors = FALSE)
colnames(HealthResources)<-c("Country","Year","Variable","var","Value")

saveRDS(HealthResources,'HealthResources')

# number of physicians employeed in hospitals

physicians[order(physicians$meanValue,decreasing = TRUE),]
  

# Import Price Data

highmarkHosp<-read.csv('us-hospitals-100-most-expensive.csv')

head(highmarkHosp)

saveRDS(highmarkHosp,"highmarkHosp")


# CCR data by states

AverageCCR<-read.csv('us-hospital-avg-charge-to-cost-ratio.csv')

head(AverageCCR)

class(AverageCCR$averageChargetoCost.Ratio)

AverageCCR_df<-data.frame(AverageCCR$ID,AverageCCR$State,AverageCCR$averageChargetoCost.Ratio)

colnames(AverageCCR_df)<-c('AverageCCR','State','averageChargetoCost.Ratio')

ggplot(AverageCCR_df,aes(averageChargetoCost.Ratio))+
geom_histogram()



# reassign the data charge  to cost ratios in USA by states

ccr_df<-AverageCCR

ccr_df<-data.frame(ccr_df$ID,ccr_df$State,ccr_df$averageChargetoCost.Ratio)

colnames(ccr_df)<-c("ID_no","STATE","AverageCCR")
head(ccr_df)

ccr_df<-saveRDS(ccr_df,'ccr_df')


# import price data

hospitalPrices<-read.csv('Cost_by_service_type.csv')

saveRDS(hospitalPrices,'hospitalPrices')

# import data for model to be done in the future.

# Import heath expenditure per capita data for OECD

healthExp<- read.csv("DP_LIVE_22122018214748365.csv",stringsAsFactors = TRUE)
head(healthExp)

colnames(healthExp)<-c("country" ,"indicator" ,  "subject"  ,   "measure"   ,  "frequency" ,  "year"   ,     "percapitaHealthExp", "Flag.Codes")

# gdp per capita data
gdp_per_capita<-read.csv('SNA_TABLE1_18012019012658457.csv')
# percentage of 65 years and older population
elderly_pop<-read.csv('DP_LIVE_18012019012035647.csv')

colnames(elderly_pop)<-c("Location",'I')
# import compulsory insurances 
govermment_compulsory_ins<- read_xls('OECD-Health-Statistics-2018-Frequently-Requested-Data.xls',sheet = 'GovtCompIns, per capita US$PPP',skip = 3)

# number of pyhsicians data
Physicians<- read_xls('OECD-Health-Statistics-2018-Frequently-Requested-Data.xls',sheet = 'Physicians',skip = 3)














