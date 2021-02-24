library(shiny)
library(plotly)

shinyUI(fluidPage(
  navbarPage("Primerjava držav s podobnimi karakteristikami po BDP in trgovanju",
             
             tabPanel("Izvoz in BDP glede na površino skozi leta",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                            inputId = "leto1",
                            label = "leto",
                            choices = c(2010:2019)
                          )
                        ),
                        mainPanel(
                          plotlyOutput(outputId = "IPo")
                        )
                      )),

              tabPanel("Izvoz in BDP glede na prebivalce skozi leta",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                          inputId = "leto2",
                          label = "leto",
                          choices = c(2010:2019)
                                       )
                                     ),
                          mainPanel(
                          plotlyOutput(outputId = "IPr")
                                     )
                                   )),

              tabPanel("Uvoz in BDP glede na površino skozi leta",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                          inputId = "leto3",
                          label = "leto",
                          choices = c(2010:2019)
                                  )
                                  ),
                          mainPanel(
                          plotlyOutput(outputId = "UPo")
                                  )
                                  )),
              tabPanel("Uvoz in BDP glede na prebivalce skozi leta",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                          inputId = "leto4",
                          label = "leto",
                          choices = c(2010:2019)
                                  )
                                  ),
                          mainPanel(
                          plotlyOutput(outputId = "UPr")
                                    )))
),
            plotlyOutput("grupiranje")                                                            
            )
)
