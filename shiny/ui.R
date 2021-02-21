library(shiny)
library(plotly)




shinyUI(fluidPage(
  plotlyOutput("UPr"),
  plotlyOutput("IPr"),
  plotlyOutput("UPo"),
  plotlyOutput("IPo"),
  plotlyOutput("grupiranje")
))

