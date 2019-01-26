sidebar<-dashboardSidebar(
  tags$blockquote('Health Spending In USA vs other OECD Countries'),
  sidebarMenu(
    menuItem("Health Spending Categories",tabName = "HealthExpCat"),
    menuItem("Healthcare Resources",tabName = "HCareResources"),
    menuItem("Healthcare Utilization",tabName = "HCareUtilization"),
    menuItem("Healthcare Quality",tabName = "HealthcareQI"),
    menuItem("Hospital Prices in",tabName = "HospitalPrices"),
    menuItem("Average Charge to Cost Ratios",tabName = "CCR"),
    menuItem("Top 100 High Markup Hospitals in USA",tabName = "highMarkup")
  )
)

healthcareQI

