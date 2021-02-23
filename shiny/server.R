library(shiny)
library(plotly)


shinyServer(function(input, output) {
  output$IPo <- renderPlotly({izvoz.in.bdp.glede.na.povrsino.shiny %>% filter(leto == input$leto1) %>% 
    ggplot(aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=povrsina,label=drzava)) + 
      geom_point() +
      ggtitle("Izvoz in BDP: površina")+  scale_x_log10() + scale_y_log10() + 
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) + ylab("količina v milijonih dolarjih") + guides(col=guide_legend("države"),
                                                                              size=guide_legend(""))
  })
  output$IPr <- renderPlotly({izvoz.in.bdp.glede.na.prebivalce.shiny %>% filter(leto == input$leto2) %>% 
      ggplot(aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=populacija,label=drzava)) + 
      geom_point() +
      ggtitle("Izvoz in BDP: prebivalci")+  scale_x_log10() + scale_y_log10() + 
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) + ylab("količina v milijonih dolarjih") +guides(col=guide_legend("države"),
                                                                             size=guide_legend(""))
  
  })

  output$UPo <- renderPlotly({uvoz.in.bdp.glede.na.povrsino.shiny %>% filter(leto == input$leto3) %>% 
      ggplot(aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=povrsina,label=drzava)) + 
      geom_point() +
      ggtitle("Uvoz in BDP: površina")+  scale_x_log10() + scale_y_log10() + 
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) + ylab("količina v milijonih dolarjih") + guides(col=guide_legend("države"),
                                                                              size=guide_legend(""))
  })
  output$UPr <- renderPlotly({uvoz.in.bdp.glede.na.prebivalce.shiny %>% filter(leto == input$leto4) %>% 
      ggplot(aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=populacija,label=drzava)) + 
      geom_point() +
      ggtitle("Uvoz in BDP: prebivalci")+  scale_x_log10() + scale_y_log10() + 
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) + ylab("količina v milijonih dolarjih") + guides(col=guide_legend("države"),
                                                                              size=guide_legend(""))
  })
  
  output$grupiranje <- renderPlotly({zdruzeno.skupaj2 %>% mutate(skupina=molK$cluster) %>%
      ggplot(aes(x=Uvoz,y=Izvoz, col=factor(skupina),label=SMTK)) + geom_point(size=3) + 
      scale_x_log10() + scale_y_log10() + theme(axis.text.x=element_blank(),
                                                axis.ticks.x=element_blank(),
                                                axis.text.y=element_blank(),
                                                axis.ticks.y=element_blank()) +
      geom_abline(slope=1, intercept=0,linetype="dashed", color = "orange")+
      ggtitle("Primerjava različnih panog glede na uvoz in izvoz leta 2019") +
      xlab("Uvoz v evrih") + ylab("Izvoz v evrih")+guides(col=guide_legend("skupine"))
  })
  
}
)
