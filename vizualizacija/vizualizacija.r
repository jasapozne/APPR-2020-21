# 3. faza: Vizualizacija podatkov







#####################################################################################
#Uvoz zemljevida 
zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", mapa = "zemljevidi", pot.zemljevida = "", encoding = "UTF-8") %>% 
  fortify() %>% filter(CONTINENT == "Europe" | SOVEREIGNT %in% c("Cyprus"), long < 45 & long > -45 & lat > 30 & lat < 75)

colnames(zemljevid)[11] <- 'drzava'
zemljevid$drzava <- as.character(zemljevid$drzava)
zemljevid$drzava[zemljevid$drzava == "Republic of Serbia"] <- "Serbia"


zemljevid.1 <- zemljevid %>% data.frame 
zemljevid.2 <- fortify(zemljevid.1)


zemljevid.trgovanja.s.eu.drzavami <- ggplot(zemljevid,
                                            aes(x=long,y=lat, group=group, color=id)) + geom_path(show.legend = FALSE)
#print(zemljevid.trgovanja.s.eu.drzavami)


################################################################################

#1. graf
graf.trgovanja.uvoz <- ggplot(viz.slo.uvz, aes(x=LETO,y=SKUPEN_UVOZ, color=DRZAVA)) + 
  geom_line(size=1.5) + geom_point(col="white",size=2) +
                                      ggtitle("Uvoz Slovenije iz držav")
#print(graf.trgovanja.uvoz)

graf.trgovanja.izvoz <- ggplot(viz.slo.izv, aes(x=LETO,y=SKUPEN_IZVOZ, color=DRZAVA)) + geom_line(size=2) + 
  geom_point(col="white",size=2) +
  ggtitle("Izvoz Slovenije iz držav")
#print(graf.trgovanja.izvoz)

##################################################################################
#2.graf 
graf.delez.uvoza <- ggplot(nadskupine.uvoz.delez, aes(x=LETO,y=DELEZ,fill=SKUPINA)) +  geom_bar(stat="identity") +
  ggtitle("Struktura Slovenskega uvoza")
##print(graf.delez.uvoza)
graf.delez.izvoza <- ggplot(nadskupine.izvoz.delez, aes(x=LETO,y=DELEZ,fill=SKUPINA)) +  geom_bar(stat="identity") +
  ggtitle("Struktura Slovenskega izvoza")
##print(graf.delez.izvoza)
#####################################################################################
#3.Graf prikazuje primerjavo uvoza in izvoza z ostalimi državami, ki so v izhodišču imele približno enako količino u/i.
graf.drzav.uvoza <- ggplot(drzave.uvoza, aes(x=leto,y=`kolicina_MIO_$`,color=drzava)) + geom_line(size=2) +
  ggtitle("Uvoz Slovenije v primerjavi z drugimi državami")
#print(graf.drzav.uvoza)
graf.drzav.izvoza <- ggplot(drzave.izvoza, aes(x=leto,y=`kolicina_MIO_$`,color=drzava)) + geom_line(size=2)+
  ggtitle("Izvoz Slovenije v primerjavi z drugimi državami")
#print(graf.drzav.izvoza)
######################################################################################
#4.Graf prikazuje primerjavo u/i in bdp po populaciji 
graf.bdp.populacija.izvoz <- ggplot(izvoz.in.bdp.glede.na.prebivalce.1, aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=populacija,label=drzava)) + 
  geom_point(show.legend = FALSE) + geom_text(aes(label=drzava),
                      alpha =ifelse(izvoz.in.bdp.glede.na.prebivalce.1$BDP>7000,1,0),hjust=1, vjust=1.4,show.legend = FALSE) +
  ggtitle("Primerjava BDP in izvoza, držav s približno enako populacijo, leta 2019")
#print(graf.bdp.populacija.izvoz)


#######################################################################################
graf.bdp.populacija.uvoz <- ggplot(uvoz.in.bdp.glede.na.prebivalce.1, aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=populacija,label=drzava)) + 
  geom_point(show.legend = FALSE) + geom_text(aes(label=drzava),
                      alpha =ifelse(uvoz.in.bdp.glede.na.prebivalce.1$BDP>8000,1,0),hjust=1, vjust=1.4,show.legend = FALSE) +
  ggtitle("Primerjava BDP in uvoza, držav s približno enako populacijo, leta 2019")
#print(graf.bdp.populacija.uvoz)
####################################################################################
#5.Graf prikazuje primerjavo u/i in bdp po povrsini

graf.bdp.povrsina.izvoz <- ggplot(izvoz.in.bdp.glede.na.povrsino, aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=povrsina,label=drzava)) + 
  geom_point(show.legend = FALSE) + geom_text(aes(label=drzava),
                      alpha =ifelse(izvoz.in.bdp.glede.na.povrsino$BDP>20000,1,0),hjust=1, vjust=1.4,show.legend = FALSE) +
  ggtitle("Primerjava BDP držav s približno enako površino, leta 2019")
#print(graf.bdp.povrsina.izvoz) 


###################################################################################
graf.bdp.povrsina.uvoz <- ggplot(uvoz.in.bdp.glede.na.povrsino, aes(x=BDP,y=`kolicina_MIO_$`,color=drzava,size=povrsina,label=drzava)) + 
  geom_point(show.legend = FALSE) + geom_text(aes(label=drzava),
                      alpha =ifelse(uvoz.in.bdp.glede.na.povrsino$BDP>20000,1,0),hjust=1, vjust=1.4,show.legend = FALSE) +
  ggtitle("Primerjava BDP držav s približno enako površino, leta 2019")
#print(graf.bdp.povrsina.uvoz)

###################################################################################
#Zemljevid

Zemljevid.Slovenskega.salda <- ggplot() + geom_polygon(STR, 
                                                       mapping = aes(x=long, y=lat, group=group, fill=skupina,color="black"))+
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) + 
  guides(fill=guide_legend("Saldo menjave Slovenije s tujino:")
         ,color=guide_legend("obrobe")) +
  ggtitle("Prikaz Slovenskega salda menjave s tujino za leto 2019") +
  labs(x = " ") +
  labs(y = " ") + scale_fill_manual(values=c("#FEE0D2","#DEEBF7","#DE2D26","#FC9272","#3182BD","#9ECAE1","orange"))
#print(Zemljevid.Slovenskega.salda)


