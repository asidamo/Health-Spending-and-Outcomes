sidebar<-dashboardSidebar(
  tags$blockquote('National Health Expenditure Per Capita'),
  sidebarMenu(
    menuItem("Per Capita Health Spending",tabName = "NHEperCapita"),
    menuItem("Health Spending Categories",tabName = "HealthExpCat"),
    menuItem("Health Care Resources",tabName = "HCareResources"),
    menuItem("Health Care Utilization",tabName = "HCareUtilization"),
    menuItem("Health Care Quality",tabName = "HealthcareQI"),
    menuItem("Hospital Prices",tabName = "HospitalPrices"),
    menuItem("Hospital Charge to Cost Ratios",tabName = "CCR")
  )
)

healthcareQI

