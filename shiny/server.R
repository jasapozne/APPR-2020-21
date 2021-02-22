library(shiny)
library(plotly)


shinyServer(function(input, output) {
  output$IPo <- renderPlotly({izvoz.in.bdp.glede.na.povrsino.shiny %>% filter(leto == input$leto) %>% 
    ggplot(aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=povrsina,label=drzava)) + 
      geom_point() +
      ggtitle("Izvoz in BDP: površina")+  scale_x_log10() + scale_y_log10() + 
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) + ylab("količina v mio $")
  })
  output$IPr <- renderPlotly({izvoz.in.bdp.glede.na.prebivalce.shiny %>% filter(leto == input$leto) %>% 
      ggplot(aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=populacija,label=drzava)) + 
      geom_point() +
      ggtitle("Izvoz in BDP: prebivalci")+  scale_x_log10() + scale_y_log10() + 
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) + ylab("količina v mio $")
  
  })

  output$UPo <- renderPlotly({uvoz.in.bdp.glede.na.povrsino.shiny %>% filter(leto == input$leto) %>% 
      ggplot(aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=povrsina,label=drzava)) + 
      geom_point() +
      ggtitle("Uvoz in BDP: površina")+  scale_x_log10() + scale_y_log10() + 
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) + ylab("količina v mio $")
  })
  output$UPr <- renderPlotly({uvoz.in.bdp.glede.na.prebivalce.shiny %>% filter(leto == input$leto) %>% 
      ggplot(aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=populacija,label=drzava)) + 
      geom_point() +
      ggtitle("Uvoz in BDP: prebivalci")+  scale_x_log10() + scale_y_log10() + 
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) + ylab("količina v mio $")
  })
  
  output$grupiranje <- renderPlotly({zdruzeno.skupaj2 %>% mutate(skupina=molK$cluster) %>%
      ggplot(aes(x=Uvoz,y=Izvoz, col=factor(skupina),label=SMTK)) + geom_point(size=3) + 
      scale_x_log10() + scale_y_log10() + theme(axis.text.x=element_blank(),
                                                axis.ticks.x=element_blank(),
                                                axis.text.y=element_blank(),
                                                axis.ticks.y=element_blank()) +
      geom_abline(slope=1, intercept=0,linetype="dashed", color = "orange")+
      ggtitle("Primerjava različnih panog glede na uvoz in izvoz leta 2019")
  })
  
}
)
