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

skupno.trgovanje <- function(trg){
  sestejmo.po.letih <- trg %>% group_by(`LETO`,`UVOZ_ALI_IZVOZ`) %>%
    summarise(SKUPAJ=sum(`KOLICINA_€`))
  return(sestejmo.po.letih)
}

skupen.uvoz <- skupno.trgovanje(uvoz.in.izvoz.Slovenije) %>%  filter(str_detect(`UVOZ_ALI_IZVOZ`,"Uvoz")) 
skupen.izvoz <- skupno.trgovanje(uvoz.in.izvoz.Slovenije) %>% filter(str_detect(`UVOZ_ALI_IZVOZ`,"Izvoz"))


predict.model.i <- lm(SKUPAJ ~ LETO, data=skupen.izvoz)
predict.model.u <- lm(SKUPAJ ~ LETO, data=skupen.uvoz)

pred.u <- data.frame(LETO=seq(2010,2021,1))
pred.i <- data.frame(LETO=seq(2010,2021,1))


napoved.u <- predict(predict.model.u,pred.u )
napoved.i <- predict(predict.model.i,pred.i )

napoved.u1 <- pred.u %>% mutate(SKUPAJ=predict(predict.model.u, .))
napoved.i1 <- pred.i %>% mutate(SKUPAJ=predict(predict.model.i, .))

napoved.za.izvoz <- ggplot(skupen.izvoz, aes(x=LETO,y=SKUPAJ/1e6)) + geom_point() + geom_smooth() +
  scale_x_continuous(breaks = seq(2010, 2021, by=1)) + 
  geom_line(data=napoved.u1, aes(x=LETO,y=SKUPAJ/1e6),color="orange",size=1.3) + 
  geom_point(data=napoved.u1, aes(x=LETO,y=SKUPAJ/1e6),color="yellow",size=2) +
  ggtitle("Napoved za izvoz Slovenije") + xlab("leto") + ylab("skupna količina izvoza v milijonih evrov")
#print(napoved.za.izvoz)

napoved.za.uvoz <- ggplot(skupen.uvoz, aes(x=LETO,y=SKUPAJ/1e6)) + geom_point() +
  scale_x_continuous(breaks = seq(2010, 2021, by=1)) + geom_smooth() +
  geom_line(data=napoved.i1, aes(x=LETO,y=SKUPAJ/1e6),color="orange",size=1.3)+
  geom_point(data=napoved.i1, aes(x=LETO,y=SKUPAJ/1e6),color="yellow",size=2.2)+
  ggtitle("Napoved za uvoz Slovenije") + xlab("leto") + ylab("skupna količina uvoza v milijonih evrov")
#print(napoved.za.uvoz)

##########skupine glede na lastnosti ############
skup <- function(trg){
  trg.1 <- trg %>% group_by(`LETO`,`SMTK`,`UVOZ_ALI_IZVOZ`) %>%
    summarise(SKUPAJ=sum(`KOLICINA_€`)) %>% filter(str_detect(`LETO`,"2019"))
  return(trg.1)
}


sk.uvoz <- skup(uvoz.in.izvoz.Slovenije) %>% filter(str_detect(`UVOZ_ALI_IZVOZ`,"Uvoz")) %>% 
  rename(Uvoz=SKUPAJ)
skupine.uvoz <- sk.uvoz[-c(3)]
sk.izvoz <- skup(uvoz.in.izvoz.Slovenije) %>% filter(str_detect(`UVOZ_ALI_IZVOZ`,"Izvoz")) %>% 
  rename(Izvoz=SKUPAJ)
skupine.izvoz <-sk.izvoz[-c(3)]

zdruzeno.skupaj <- full_join(skupine.uvoz,skupine.izvoz )

zdruzeno.skupaj1 <- zdruzeno.skupaj[-c(1,2)] %>% filter(Izvoz > 1e+3)
izpuscene.panoge <- zdruzeno.skupaj %>% filter(Izvoz < 1e+3)

zdruz <- zdruzeno.skupaj1 %>% as.matrix() %>% scale()
D <- dist(zdruz)
mol <- hclust(D)
#plot(mol,hang=-1, cex=0.3, main=zdruzeno.skupaj1)
p <- cutree(mol,h=2)


molK <- kmeans(zdruzeno.skupaj1,5)

zdruzeno.skupaj2 <- left_join(zdruzeno.skupaj1,zdruzeno.skupaj) %>% select(-3)

graf.skupin.panog <-  zdruzeno.skupaj2 %>% mutate(skupina=molK$cluster) %>%
  ggplot( aes(x=Uvoz,y=Izvoz, col=factor(skupina))) + geom_point(size=3) + 
  scale_x_log10() + scale_y_log10() + theme(axis.text.x=element_blank(),
                                            axis.ticks.x=element_blank(),
                                            axis.text.y=element_blank(),
                                            axis.ticks.y=element_blank()) +
  geom_abline(slope=1, intercept=0,linetype="dashed", color = "orange")
#print(graf.skupin.panog)
