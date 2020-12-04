# 2. faza: Uvoz podatkov

#################################

library(readr)
library(dplyr)
library(tidyr)
library(httr)
require(rvest)
require(XML)
require(stringr)

####################################



sl <- locale("sl", decimal_mark=",", grouping_mark=".")

# Funkcija, ki uvozi občine iz Wikipedije
uvozi.obcine <- function() {
  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec=",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    if (is.character(tabela[[col]])) {
      tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
    }
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.druzine <- function(obcine) {
  data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
                    locale=locale(encoding="Windows-1250"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- iconv("Sveti Jurij ob Ščavnici", to="UTF-8")
  data <- data %>% pivot_longer(`1`:`4`, names_to="velikost.druzine", values_to="stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- parse_factor(data$obcina, levels=obcine)
  return(data)
}

# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.

#1. tabela
uvazanje <- function(){
uvoz <-read_csv("podatki/Uvoz.csv",
              locale=locale(encoding="Windows-1250"),skip = 6, col_names=TRUE) %>% select(-1) %>% 
  pivot_longer(c(-1), names_to="leto",values_to="kolicina (MIO $)",values_drop_na=TRUE) %>%
  mutate(leto=parse_number(leto)) %>% rename(drzava=X2)  

uvoz.1 <-uvoz$drzava %>% str_remove("\\.|,|:[A-Za-z ]*") %>%
  str_replace("SĂŁo TomĂ© and PrĂ\\­ncipe Dem\\.", "Sao Tome and Principe") %>%
  str_remove("Rep. [a-zA-Z .]*") %>%str_remove("Rep")

uvoz[["drzava"]] <- uvoz.1
return(uvoz)
}
uvoz.vseh.drzav <- uvazanje()

#2.tabela
izvazanje <- function(){
izvoz <-read_csv("podatki/Izvoz.csv",
                locale=locale(encoding="Windows-1250"),skip = 6, col_names=TRUE) %>% select(-1) %>%
  pivot_longer(c(-1), names_to="leto",values_to="kolicina (MIO $)",values_drop_na=TRUE) %>%
  mutate(leto=parse_number(leto)) %>% rename(drzava=X2) 

izvoz.1 <-izvoz$drzava %>% str_remove("\\.|,|:[A-Za-z ]*") %>%
  str_replace("SĂŁo TomĂ© and PrĂ\\­ncipe\\. Rep\\. of", "Sao Tome and Principe") %>%
  str_remove("Rep. [a-zA-Z .]*") %>% str_remove("Rep") %>% str_remove("The")

izvoz[["drzava"]] <- izvoz.1
return(izvoz)
}

izvoz.vseh.drzav <- izvazanje()

#3. tabela
uvoz.in.izvoz <- function(){
UI.SLO <-read_csv("podatki/UinIpoSMTK.csv",
                 locale=locale(encoding="Windows-1250")) %>%  pivot_longer(c(-1,-2,-3), 
                  names_to="LETO",values_to="KOLICINA (€)",values_drop_na=TRUE) %>%
                  mutate(LETO=parse_number(LETO)) %>% rename(SMTK=3) 

IU.SLO <- UI.SLO$DRŽAVA %>% str_replace("[A-Z]* ","") 
UI.SLO[["DRŽAVA"]] <- IU.SLO
return(UI.SLO)
}
uvoz.in.izvoz.Slovenije <- uvoz.in.izvoz()

#4. tabela
drzave.sveta <- function(){
url <- "https://www.worldometers.info/world-population/population-by-country/"
naslov <- read_html(url)
podatki.drzav <- naslov %>% html_nodes(xpath="//table[@id='example2']") %>% 
  .[[1]] %>% html_table(dec=".") %>% select(2,3,7) %>% rename(Country=1,Population=2)

populacija.bv <- podatki.drzav$Population %>% str_replace_all(",","")
povrsina.bv <- podatki.drzav$`Land Area (Km²)` %>% str_replace_all(",","")  

podatki.drzav[["Population"]] <- populacija.bv
podatki.drzav[[3]] <- povrsina.bv

podatki.drzav$Population <- as.numeric(as.character(podatki.drzav$Population))
podatki.drzav$`Land Area (Km²)` <- as.numeric(as.character(podatki.drzav$`Land Area (Km²)`))

return(podatki.drzav)
}
podatki.o.drzavah <- drzave.sveta()