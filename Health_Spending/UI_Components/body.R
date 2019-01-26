source("./UI_Components/tabs/HealthExpCategories_tab.R")
source("./UI_Components/tabs/HealthCareResources_tab.R")
source("./UI_Components/tabs/HCareUtilization_tab.R")
source("./UI_Components/tabs/HealthCareQuality_tab.R")
source("./UI_Components/tabs/HospitalPrices_tab.R")
source("./UI_Components/tabs/ChargetoCostRatio_tab.R")
source("./UI_Components/tabs/highmarkup_tab.R")
body<-dashboardBody(
  tabItems(
    HealthExpCategories_tab,
    HCareUtilization_tab,
    HealthCareResources_tab,
    HealthCareQuality_tab,
    HospitalPrices_tab,
    ChargetoCostRatio_tab,
    highmarkup_tab
    
  )
  
)
