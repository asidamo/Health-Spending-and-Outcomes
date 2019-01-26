source("./Server_Components/HealthExpCategories_Server.R")
source("./Server_Components/HealthCareResources_Server.R")
source("./Server_Components/HCareUtilization_Server.R")
source("./Server_Components/HealthCareQuality_Server.R")
source("./Server_Components/HospitalPrices_Server.R")
source("./Server_Components/ChargeToCostRatio_Server.R")
source("./Server_Components/HighMarkupHospitals_Server.R")
# Define server logic required to draw a line plot

shinyServer(function(input, output,Session) {
  
   HealthExpCategories_Server(input,output,Session)
  HealthCareResources_Server(input,output,Session)
  HCareUtilization_Server(input,output,Session)
  HealthCareQuality_Server(input,output,Session)
  HospitalPrices_Server(input,output,Session)
  ChargeToCostRatio_Server(input,output,Session)
  HighMarkupHospitals_Server(input,output,Session)
  
})
