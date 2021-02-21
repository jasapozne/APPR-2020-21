library(shiny)
library(plotly)

shinyServer(function(input, output) {

  output$UPr <- renderPlotly({ggplot(uvoz.in.bdp.glede.na.prebivalce.1, aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=populacija,label=drzava)) + 
    geom_point() + geom_text(aes(label=drzava),
                                                alpha =ifelse(uvoz.in.bdp.glede.na.prebivalce.1$drzava=="Slovenia",1,0)) +
    ggtitle("Primerjava BDP in uvoza, držav s približno enako populacijo, leta 2019") +  scale_x_log10() + scale_y_log10() +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank()) 
  })
  
  output$IPr <- renderPlotly({graf.bdp.populacija.izvoz <- ggplot(izvoz.in.bdp.glede.na.prebivalce.1, 
                                                                  aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=populacija,label=drzava)) + 
    geom_point() + 
    geom_text(aes(label=drzava),
              alpha =ifelse(izvoz.in.bdp.glede.na.prebivalce.1$drzava=="Slovenia",1,0),
              hjust=1, vjust=1.4) +
    ggtitle("Primerjava BDP in izvoza, držav s približno enako populacijo, leta 2019") +  
    scale_x_log10() + scale_y_log10() +
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank())
  
  })
  output$UPo <- renderPlotly({ggplot(uvoz.in.bdp.glede.na.povrsino, aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=povrsina,label=drzava)) + 
    geom_point() + geom_text(aes(label=drzava),
                                                alpha =ifelse(uvoz.in.bdp.glede.na.povrsino$drzava=="Slovenia",1,0),hjust=1, vjust=1.4) +
    ggtitle("Primerjava BDP in izvoza držav s približno enako površino, leta 2019")+  scale_x_log10() + scale_y_log10() + 
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank())
  })
    output$IPo <- renderPlotly({ggplot(izvoz.in.bdp.glede.na.povrsino, aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=povrsina,label=drzava)) + 
    geom_point() + geom_text(aes(label=drzava),
                                                alpha =ifelse(izvoz.in.bdp.glede.na.povrsino$drzava=="Slovenia",1,0),hjust=1, vjust=1.4) +
    ggtitle("Primerjava BDP in uvoza držav s približno enako površino, leta 2019") +  scale_x_log10() + scale_y_log10() + 
    theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank())
  
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

