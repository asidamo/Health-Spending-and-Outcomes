source('./UI_Components/header.R')
source('./UI_Components/sidebar.R')
source('./UI_Components/body.R')
# Define server logic required to draw a line plot
shinyUI(
  dashboardPage(
    header = header,
    sidebar = sidebar,
    body = body

  )
)

