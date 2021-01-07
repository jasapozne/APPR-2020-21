# 4. faza: Analiza podatkov

#podatki <- obcine %>% transmute(obcina, povrsina, gostota,
#                                gostota.naselij=naselja/povrsina) %>%
#  left_join(povprecja, by="obcina")
#row.names(podatki) <- podatki$obcina
#podatki$obcina <- NULL

# Število skupin
#n <- 5
#skupine <- hclust(dist(scale(podatki))) %>% cutree(n)

#skupine držav, ki imajo približno enak:

memory.limit(size=100000)

skupine.drzav <- function(trgovanje){
trgovanje.brez <- trgovanje$'drzava' %>% str_replace("Belgium-Luxembourg","Bel")
trgovanje$'drzava' <- trgovanje.brez
izbrane.drzave <- trgovanje %>% filter(str_detect(drzava,"Slovenia") | str_detect(drzava,"Bulgaria") | str_detect(drzava,"New Zealand")
                            |str_detect(drzava,"Luxembourg")| str_detect(drzava,"Oman") | str_detect(drzava,"Peru") |
                              str_detect(drzava,"Ecuador")| str_detect(drzava,"Syrian Arab"))
return(izbrane.drzave)

}
#-UVOZ:
drzave.uvoza <- skupine.drzav(uvoz.vseh.drzav)
#-IZVOZ
drzave.izvoza <- skupine.drzav(izvoz.vseh.drzav)


#dražave s približno enako populacijo in površino kot Slovenija

drzave.s.e.populacijo <- podatki.o.drzavah %>% filter(populacija <(2078938 * 2)) %>% 
  filter(populacija > (2078938/2)) %>% select(-povrsina)

drzave.s.e.povrsino <- podatki.o.drzavah %>% filter(povrsina <(20140 * 2)) %>% 
  filter(povrsina > (20140/2)) %>% select(-populacija)



drzave.po.populaciji.in.bdp <- left_join(drzave.s.e.populacijo,nominalni.BDP.per.capita)
drzave.po.povrsini.in.bdp <- left_join(drzave.s.e.povrsino,nominalni.BDP.per.capita)

gdp.ex<- izvoz.vseh.drzav %>% filter(str_detect(leto,"2019")) 
gdp.im <- uvoz.vseh.drzav %>% filter(str_detect(leto,"2019"))

bdp.uvoz.izvoz <- function(im.ex){
izvoz.nekaterih.drzav <- im.ex$drzava %>% str_remove("The") %>% str_replace(" ","") %>%
  str_replace("TaiwanProvince of China","Taiwan") %>% str_replace("Kingdom of","") %>%
  str_replace("Timor\\-Leste Dem\\. ","Timor\\-Leste") %>% str_replace("NewCaledonia", "New Caledonia") %>%
  str_replace("ElSalvador","El Salvador") %>% str_replace("NorthMacedonia","North Macedonia") %>% 
  str_replace("EquatorialGuinea","Equatorial Guinea") %>% str_replace("SolomonIslands","Solomon Islands") %>%
  str_replace("FalklandIslands \\(Malvinas\\)","Falkland Islands") %>% str_replace(" State of","") %>% 
  str_replace("Bosniaand Herzegovina","Bosnia and Herzegovina") %>% str_replace("PuertoRico","Puerto Rico") %>%
  str_replace(" ublic of","") %>% str_replace("Trinidadand Tobago","Trinidad and Tobago")
return(izvoz.nekaterih.drzav)
}
gdp.ex$drzava <- bdp.uvoz.izvoz(gdp.ex)
gdp.im$drzava <- bdp.uvoz.izvoz(gdp.im)



izvoz.in.bdp.glede.na.prebivalce<- left_join(drzave.po.populaciji.in.bdp,gdp.ex)
izvoz.in.bdp.glede.na.povrsino<- left_join(drzave.po.povrsini.in.bdp,gdp.ex)
uvoz.in.bdp.glede.na.prebivalce<- left_join(drzave.po.populaciji.in.bdp,gdp.im)
uvoz.in.bdp.glede.na.povrsino<- left_join(drzave.po.povrsini.in.bdp,gdp.im)

uvoz.in.bdp.glede.na.povrsino.2 <- uvoz.in.bdp.glede.na.povrsino %>% arrange(BDP) %>% slice(19:30)
izvoz.in.bdp.glede.na.povrsino.2 <- izvoz.in.bdp.glede.na.povrsino %>% arrange(BDP) %>% slice(19:30)
uvoz.in.bdp.glede.na.povrsino.1 <- uvoz.in.bdp.glede.na.povrsino %>% arrange(BDP) %>% slice(1:18)
izvoz.in.bdp.glede.na.povrsino.1 <- izvoz.in.bdp.glede.na.povrsino %>% arrange(BDP) %>% slice(1:18)
uvoz.in.bdp.glede.na.prebivalce.2 <- uvoz.in.bdp.glede.na.prebivalce %>% arrange(BDP) %>% slice(13:30)
izvoz.in.bdp.glede.na.prebivalce.2 <- izvoz.in.bdp.glede.na.prebivalce %>% arrange(BDP) %>% slice(10:30)
uvoz.in.bdp.glede.na.prebivalce.1 <- uvoz.in.bdp.glede.na.prebivalce %>% arrange(BDP) %>% slice(1:27)
izvoz.in.bdp.glede.na.prebivalce.1 <- izvoz.in.bdp.glede.na.prebivalce %>% arrange(BDP) %>% slice(1:27)

###################################################################
#top 10 držav s katerimi Slovenija trguje
slovenija.izvoz <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,"Izvoz")) %>%
  arrange(`KOLICINA_€`) %>% arrange(LETO) %>% filter(str_detect(DRZAVA,"Švica") | str_detect(DRZAVA,"Nemčija") | str_detect(DRZAVA,"Francija")
                    |str_detect(DRZAVA,"Italija")| str_detect(DRZAVA,"Hrvaška") | str_detect(DRZAVA,"Avstrija") |
                    str_detect(DRZAVA,"Poljska")| str_detect(DRZAVA,"Srbija") | str_detect(DRZAVA,"Madžarska")| str_detect(DRZAVA,"Rusija")|str_detect(DRZAVA,"Nizozemska"))



### države s katerimi največ izvažamo
viz.slo.izv <- slovenija.izvoz %>% group_by(LETO,DRZAVA) %>% summarise(SKUPEN_IZVOZ=sum(`KOLICINA_€`)) %>%
  arrange(-SKUPEN_IZVOZ) %>% arrange(-LETO) 



##### države s katerimi veliko uvažamo
slovenija.uvoz <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,"Uvoz")) %>% 
  arrange(`KOLICINA_€`) %>% arrange(`LETO`) %>% filter(str_detect(DRZAVA,"Švica") | str_detect(DRZAVA,"Nemčija") | str_detect(DRZAVA,"Francija")
                                                       |str_detect(DRZAVA,"Italija")| str_detect(DRZAVA,"Hrvaška") | str_detect(DRZAVA,"Avstrija") |
                                                         str_detect(DRZAVA,"Poljska")|str_detect(DRZAVA,"Kitajska") |
                                                         str_detect(DRZAVA,"Madžarska")| str_detect(DRZAVA,"Nizozemska"))


viz.slo.uvz <- slovenija.uvoz %>% group_by(LETO,DRZAVA) %>% summarise(SKUPEN_UVOZ=sum(`KOLICINA_€`)) %>%
  arrange(-SKUPEN_UVOZ) %>% arrange(-LETO)

POPOPO <-viz.slo.uvz %>% group_by(DRZAVA) %>% filter(SKUPEN_UVOZ==max(SKUPEN_UVOZ))
###################################################################

#ustvariš nadskupine

nadskupine.blaga <- function(blago){
izvoz.1.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"0[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.1.nadskupina$SKUPINA <- "Žive živali in živila"
izvoz.2.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"1[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.2.nadskupina$SKUPINA <- "Pijače in tobak"
izvoz.3.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"2[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.3.nadskupina$SKUPINA <- "Surove snovi"
izvoz.4.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"3[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.4.nadskupina$SKUPINA <- "Mineralna goriva in maziva"
izvoz.5.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"4[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.5.nadskupina$SKUPINA <- "Olja, masti, voski živali"
izvoz.6.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"5[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.6.nadskupina$SKUPINA <- "Kemični proizvodi"
izvoz.7.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"6[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.7.nadskupina$SKUPINA <- "Izdelki po materialu"
izvoz.8.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"7[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.8.nadskupina$SKUPINA <- "Stroji in transportne naprave"
izvoz.9.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"8[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.9.nadskupina$SKUPINA <- "Razni izdelki"
izvoz.10.nadskupina <- uvoz.in.izvoz.Slovenije %>% filter(str_detect(UVOZ_ALI_IZVOZ,blago)) %>%
  filter(str_detect(SMTK,"9[0-9]")) %>% group_by(LETO) %>% summarise(KOLICINA=sum(`KOLICINA_€`)) 
izvoz.10.nadskupina$SKUPINA <- "Proizvodi in transakcije"

wer1 <- full_join(izvoz.1.nadskupina,izvoz.2.nadskupina)
wer2 <- full_join(izvoz.3.nadskupina,izvoz.4.nadskupina)
wer3 <- full_join(izvoz.5.nadskupina,izvoz.6.nadskupina)
wer4 <- full_join(izvoz.7.nadskupina,izvoz.8.nadskupina)
wer5 <- full_join(izvoz.9.nadskupina,izvoz.10.nadskupina)
wer6 <- full_join(wer1,wer2)
wer7 <- full_join(wer3,wer4)
wer8 <- full_join(wer5,wer6)
wer9 <- full_join(wer7,wer8)
return(wer9)
}

nadskupine.za.izvoz <- nadskupine.blaga("Izvoz")
nadskupine.za.uvoz <- nadskupine.blaga("Uvoz")



delez.uv.iz <- function(delez){
vsota.vseh <- delez %>% group_by(LETO) %>% summarise(SKUPNA_KOLICINA=sum(KOLICINA))
dodajmo.skupno.kolicino <- left_join(delez,vsota.vseh)
delez.skupine <- dodajmo.skupno.kolicino %>% group_by(LETO,SKUPINA) %>% mutate(DELEZ=KOLICINA/SKUPNA_KOLICINA)
}

nadskupine.izvoz.delez <- delez.uv.iz(nadskupine.za.izvoz) 
nadskupine.uvoz.delez <- delez.uv.iz(nadskupine.za.uvoz)

##########################
#Zemljevid naj vsebuje Evropske države in njihov saldo
drzave.u.in.i <-uvoz.in.izvoz.Slovenije
uini.SLO <- drzave.u.in.i$DRZAVA %>% str_replace("Ukrajina","Ukraine") %>%
  str_replace("Francija","France") %>% str_replace("Španija","Spain") %>% str_replace("Švedska","Sweden") %>% str_replace("Luksemburg","Luxembourg") %>%
  str_replace("Norveška","Norway") %>% str_replace("Nemčija","Germany") %>% str_replace("Finska","Finland") %>% 
  str_replace("Poljska","Poland") %>% str_replace("Italija","Italy") %>% str_replace("Združeno kraljestvo","United Kingdom") %>%
  str_replace("Romunija","Romania") %>% str_replace("Belorusija","Belarus") %>% str_replace("Grčija","Greece") %>%
  str_replace("Bolgarija","Bulgaria") %>% str_replace("Islandija","Iceland") %>% str_replace("Madžarska","Hungary") %>% 
  str_replace("Portugalska","Portugal") %>% str_replace("Srbija","Republic of Serbia") %>% str_replace("Irska","Ireland") %>%
  str_replace("Latvija","Lithuania") %>% str_replace("Litva","Latvia") %>% str_replace("Hrvaška","Croatia") %>%
  str_replace("Bosna in Hercegovina","Bosnia and Herzegovina") %>% str_replace("Estonija","Estonia") %>% str_replace("Danska","Denmark") %>% 
  str_replace("Švica","Switzerland") %>% str_replace("Nizozemska","Netherlands") %>% str_replace("Moldavija Republika","Moldova") %>%
  str_replace("Belgija","Belgium") %>% str_replace("Albanija","Albania") %>% str_replace("Republika Severna Makedonija","Macedonia") %>%
  str_replace("Turčija","Turkey") %>% str_replace("Črna gora","Montenegro") %>% str_replace("Ciper","Cyprus") %>% str_replace("Slovaška","Slovakia") %>%
  str_replace("Češka republika","Czechia") %>% str_replace("Avstrija","Austria") %>% str_replace("Andora","Andorra") %>% str_replace("Lihtenštajn","Liechtenstein") %>%
  str_replace("Monako","Monaco") %>% str_replace("Sveti sedež (Vatikanska mestna država)","Vatican") %>% str_replace("Ruska federacija","Russia") %>% str_replace("Republic of Serbia in Črna gora","Yugoslavia")

drzave.u.in.i$DRZAVA <- uini.SLO
  
samo.leto.2019 <- drzave.u.in.i %>% filter(str_detect(LETO,"2019"))

vse.skupaj.za.2019 <- samo.leto.2019 %>% group_by(DRZAVA,`UVOZ_ALI_IZVOZ`) %>% summarise(sestevek=sum(`KOLICINA_€`))



spremenjen.predznak.uvoza <- vse.skupaj.za.2019 %>% filter(str_detect(UVOZ_ALI_IZVOZ,"Uvoz")) %>% mutate(sestevek=sestevek*-1)
izvoz.bo.isti.kot.je.bil <- vse.skupaj.za.2019 %>% filter(str_detect(UVOZ_ALI_IZVOZ,"Izvoz"))

saldo.kmalu <- full_join(izvoz.bo.isti.kot.je.bil,spremenjen.predznak.uvoza)

izracun.salda <- saldo.kmalu %>% group_by(DRZAVA) %>% summarise(saldo_menjave=sum(sestevek))
izbrisimo.presledek <- izracun.salda$DRZAVA %>% str_replace("Republic of Serbia ","Serbia")%>% 
  str_replace("Macedonia ","Macedonia") %>% str_replace("Montenegro ","Montenegro") %>% str_replace("Kosovo ","Kosovo")
izracun.salda$DRZAVA <- izbrisimo.presledek



poz.saldo <- izracun.salda %>% filter(saldo_menjave>=0) 
poz.saldo$ialiu <- "Izvoz"
poz.saldo.1 <- poz.saldo %>% filter(saldo_menjave<=46451811)
poz.saldo.1$skupina <- "do 46451811"
poz.saldo.2 <- poz.saldo %>% filter(saldo_menjave >= 46451811) %>% filter(saldo_menjave<=146158188)
poz.saldo.2$skupina <- "od 46451812 do 146158188"
poz.saldo.3 <- poz.saldo %>% filter(saldo_menjave>146158188)
poz.saldo.3$skupina <- "od 146158189 do 1170205678"                          
neg.saldo <- izracun.salda %>% filter(saldo_menjave<0)
neg.saldo$ialiu <- "Uvoz"
neg.saldo.1 <- neg.saldo %>% filter(saldo_menjave>=(-76289086)) 
neg.saldo.1$skupina <- "do -76289086"
neg.saldo.2 <- neg.saldo %>% filter(saldo_menjave<(-76289086)) %>% filter(saldo_menjave>=(-317189621))
neg.saldo.2$skupina <- "od -76289087 do -317189621"
neg.saldo.3 <- neg.saldo %>% filter(saldo_menjave<(-317189621))
neg.saldo.3$skupina <- "od -317189622 do -1112788761"


weri1 <- full_join(poz.saldo.1,poz.saldo.2)
weri2 <- full_join(neg.saldo.3,poz.saldo.3)
weri3 <- full_join(neg.saldo.1,neg.saldo.2)
weri4 <- full_join(weri1,weri3)


izracun.saldo.s.skupinami <- full_join(weri4,weri2)

STR.b <- left_join(zemljevid.2,izracun.saldo.s.skupinami, by=c("drzava"="DRZAVA"))

dodajmo.se.SLO <- STR.b %>% filter(str_detect(drzava,"Slovenia"))
dodajmo.se.SLO$skupina <- "Slovenia"
dodajmo.se.SLO$ialiu <- "Uvoz"

STR.a <- full_join(STR.b,dodajmo.se.SLO)
STR <- STR.a %>% filter(str_detect(skupina,"[a-zA-Z0-9+-]*"))

saldo.v.eu.1 <- STR %>% select(11,102) %>% distinct(.keep_all = TRUE)


neg.sk.sa <- saldo.v.eu.1  %>% filter(saldo_menjave<(0)) 
poz.sk.sa <- saldo.v.eu.1 %>% filter(saldo_menjave>(0))
neg.sk1 <- quantile(neg.sk.sa$saldo_menjave,seq(0,1,1/3),na.rm=TRUE)
poz.sk1 <- quantile(poz.sk.sa$saldo_menjave,seq(0,1,1/3),na.rm=TRUE)
barvajmo.1 <- brewer.pal(poz.sk1,"Blues")
barvajmo.2 <- brewer.pal(neg.sk1,"Reds")
######################################################################


