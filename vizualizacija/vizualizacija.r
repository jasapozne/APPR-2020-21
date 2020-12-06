# 3. faza: Vizualizacija podatkov


###################################

library(ggplot2)

###################################

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
                             pot.zemljevida="OB", encoding="Windows-1250")
# Če zemljevid nima nastavljene projekcije, jo ročno določimo
proj4string(zemljevid) <- CRS("+proj=utm +zone=10+datum=WGS84")

levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))

#####################################################################################
#Preliminarna analiza


surovine.izvazanja.in.uvazanja <- uvoz.in.izvoz.Slovenije %>% group_by(`UVOZ/IZVOZ`,SMTK) %>%
  summarise(POVPRECJE=mean(`KOLICINA (€)`))

povprecje.uvoza <- uvoz.vseh.drzav %>% group_by(drzava) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
povprecje.izvoza <- izvoz.vseh.drzav %>% group_by(drzava) %>% summarise(povprecje=mean(`kolicina (MIO $)`))

#1. graf
trgovanje <- ggplot(povprecje.trgovanja, aes(x=DRŽAVA,y=POVPRECJE)) + geom_point()

#2. graf
graf.izvoz <- ggplot(povprecje.izvoza, aes(x=drzava,y=povprecje)) + geom_point()


#3.graf 
graf.uvoz <- ggplot(povprecje.uvoza, aes(x=drzava,y=povprecje, color=drzava)) + geom_point()

#4.graf
graf.blago <- ggplot(surovine.izvazanja.in.uvazanja, aes(x=SMTK,y=POVPRECJE, color=SMTK)) + geom_point()

