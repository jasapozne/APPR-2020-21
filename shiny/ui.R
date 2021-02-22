library(shiny)
library(plotly)

shinyUI(fluidPage(
  navbarPage("Primerjava držav s podobnimi karakteristikami po BDP in trgovanju",
             
             tabPanel("Izvoz in BDP glede na površino skozi leta",
                      titlePanel(title = h2("Izvoz in bdp glede na površino")),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                            inputId = "leto",
                            label = "leto",
                            choices = c("2010", "2011", "2012","2013","2014","2015","2016","2017",
                                        "2018","2019")
                          )
                        ),
                        mainPanel(
                          plotlyOutput(outputId = "IPo")
                        )
                      )),

              tabPanel("Izvoz in BDP glede na prebivalce skozi leta",
                      titlePanel(title = h2("Izvoz in bdp glede na prebivalce")),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                          inputId = "leto",
                          label = "leto",
                          choices = c("2010", "2011", "2012","2013","2014","2015","2016","2017",
                                                     "2018","2019")
                                       )
                                     ),
                          mainPanel(
                          plotlyOutput(outputId = "IPr")
                                     )
                                   )),

              tabPanel("Uvoz in BDP glede na površino skozi leta",
                      titlePanel(title = h2("Uvoz in bdp glede na povrsino")),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                          inputId = "leto",
                          label = "leto",
                          choices = c("2010", "2011", "2012","2013","2014","2015","2016","2017",
                                                                  "2018","2019")
                                  )
                                  ),
                          mainPanel(
                          plotlyOutput(outputId = "UPo")
                                  )
                                  )),
              tabPanel("Uvoz in BDP glede na prebivalce skozi leta",
                      titlePanel(title = h2("Uvoz in bdp glede na prebivalce")),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(
                          inputId = "leto",
                          label = "leto",
                          choices = c("2010", "2011", "2012","2013","2014","2015","2016","2017",
                                                                               "2018","2019")
                                  )
                                  ),
                          mainPanel(
                          plotlyOutput(outputId = "UPr")
                                    ))),
 
            plotlyOutput("grupiranje")                                                            
            ))
)
