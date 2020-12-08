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
povprecje.trgovanja <- uvoz.in.izvoz.Slovenije %>% group_by(`UVOZ/IZVOZ`,DRŽAVA) %>%
  summarise(POVPRECJE=mean(`KOLICINA (€)`)) %>% filter(POVPRECJE > 5e+04)


surovine.izvazanja.in.uvazanja <- uvoz.in.izvoz.Slovenije %>% group_by(`UVOZ/IZVOZ`,SMTK) %>%
  summarise(POVPRECJE=mean(`KOLICINA (€)`)) %>% filter(POVPRECJE > 0)


skupina.u <- izvoz.vseh.drzav %>% arrange(`kolicina (MIO $)`)
skupina.u1 <- skupina.u %>% slice(1:500) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.u1$skupina <- "A"
skupina.u2 <- skupina.u %>% slice(501:1000) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.u2$skupina <- "B"
skupina.u3 <- skupina.u %>% slice(1001:1500) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.u3$skupina <- "C"
skupina.u4 <- skupina.u %>% slice(1501:2000) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.u4$skupina <- "D"
skupina.u5 <- skupina.u %>% slice(2001:2500) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.u5$skupina <- "E"

weru1 <- full_join(skupina.u1,skupina.u2)
weru2 <- full_join(skupina.u3,weru1)
weru3 <- full_join(weru2,skupina.u4)
weru4 <- full_join(skupina.u5,weru3)

uvoz.po.skupinah.skozi.leta.m <- weru2
uvoz.po.skupinah.skozi.leta.s <- weru3
uvoz.po.skupinah.skozi.leta.v <- weru4


skupina.i <- izvoz.vseh.drzav %>% arrange(`kolicina (MIO $)`)
skupina.i1 <- skupina.i %>% slice(1:500) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.i1$skupina <- "A"
skupina.i2 <- skupina.i %>% slice(501:1000) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.i2$skupina <- "B"
skupina.i3 <- skupina.i %>% slice(1001:1500) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.i3$skupina <- "C"
skupina.i4 <- skupina.i %>% slice(1501:2000) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.i4$skupina <- "D"
skupina.i5 <- skupina.i %>% slice(2001:2500) %>% group_by(leto) %>% summarise(povprecje=mean(`kolicina (MIO $)`))
skupina.i5$skupina <- "E"

weri1 <- full_join(skupina.i1,skupina.i2)
weri2 <- full_join(weri1,skupina.i3)
weri3 <- full_join(weri2,skupina.i4)
weri4 <- full_join(skupina.i5,weri3)

izvoz.po.skupinah.skozi.leta.m <- weri2
izvoz.po.skupinah.skozi.leta.s <- weri3
izvoz.po.skupinah.skozi.leta.v <- weri4

drzave.s.e.populacijo <- podatki.o.drzavah %>% filter(Population <(2078938 * 3)) %>% filter(Population > (2078938/3))

drzave.s.e.povrsino <- podatki.o.drzavah %>% filter(`Land Area (Km²)` <(20140 * 3.6)) %>% filter(`Land Area (Km²)` > (20140/3))


#1. graf
graf.trgovanja <- ggplot(povprecje.trgovanja, aes(x=POVPRECJE,y=DRŽAVA, color=`UVOZ/IZVOZ`)) + geom_point()

#2. graf
graf.uvoza.skozi.leta.m <- ggplot(uvoz.po.skupinah.skozi.leta.m,aes(x=leto, y=povprecje, color=skupina)) + geom_line()
graf.uvoza.skozi.leta.s <- ggplot(uvoz.po.skupinah.skozi.leta.s,aes(x=leto, y=povprecje, color=skupina)) + geom_line()
graf.uvoza.skozi.leta.v <- ggplot(uvoz.po.skupinah.skozi.leta.v,aes(x=leto, y=povprecje, color=skupina)) + geom_line()

#3.graf 
graf.izvoza.skozi.leta.m <- ggplot(izvoz.po.skupinah.skozi.leta.m,aes(x=leto, y=povprecje, color=skupina)) + geom_line()
graf.izvoza.skozi.leta.s <- ggplot(izvoz.po.skupinah.skozi.leta.s,aes(x=leto, y=povprecje, color=skupina)) + geom_line()
graf.izvoza.skozi.leta.v <- ggplot(izvoz.po.skupinah.skozi.leta.v,aes(x=leto, y=povprecje, color=skupina)) + geom_line()

#4.graf
graf.blago <- ggplot(surovine.izvazanja.in.uvazanja, aes(x=POVPRECJE,y=SMTK,color=`UVOZ/IZVOZ`)) + geom_point()

#5.graf
graf.povrsina <- ggplot(drzave.s.e.povrsino, aes(x=Country,y=`Land Area (Km²)`)) + geom_point()

#6.graf
graf.populacija <- ggplot(drzave.s.e.populacijo, aes(x=Country,y=Population)) + geom_point()


