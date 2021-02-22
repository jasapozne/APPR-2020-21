# 2. faza: Uvoz podatkov



#1. in 2. tabela
trim <- function( x ) {
  gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)
}

uvozi <- function(ime_datoteke){
  ime <- paste0("podatki/",ime_datoteke, ".csv")
  uvoz <-read_csv(ime, locale=locale(encoding="UTF-8"),skip = 6, col_names=TRUE) %>% select(-1) %>% 
    pivot_longer(c(-1), names_to="leto",values_to="kolicina_MIO_$",values_drop_na=TRUE) %>%
    mutate(leto=parse_number(leto)) %>% rename(drzava=X2)  
  
  uvoz.1 <-uvoz$drzava %>% str_remove("\\.|,|:[A-Za-z ]*") %>%
    str_remove("Rep. [a-zA-Z .]*") %>%str_remove("Rep") %>%
    str_replace("São Tomé and Príncipe Dem\\. ", "Sao Tome and Principe") %>%
    str_replace("Côte d'Ivoire","Ivory Coast") %>% 
    str_replace("Curaçao Kingdom of the Netherlands","Curacao") %>% str_remove(" The") %>% str_remove(" Province of China") %>%
    str_remove(" ublic of") %>% str_remove(" Kingdom of") %>% str_remove(" Dem.") %>% str_remove(" State of")
  
  uvoz$drzava <- trim(uvoz.1) 
  return(uvoz)
} 
uvoz.vseh.drzav <- uvozi("Uvoz")
izvoz.vseh.drzav <- uvozi("Izvoz")

#3. tabela
uvoz.in.izvoz <- function(){
UI.SLO <-read_csv("podatki/UinIpoSMTK.csv",
                 locale=locale(encoding="Windows-1250")) %>%  pivot_longer(c(-1,-2,-3), 
                  names_to="LETO",values_to="KOLICINA_€",values_drop_na=TRUE) %>%
                  mutate(LETO=parse_number(LETO)) %>% rename(SMTK=3,DRZAVA=2,UVOZ_ALI_IZVOZ=1) 

IU.SLO <- UI.SLO$DRZAVA %>% str_replace("[A-Z]* ","") %>% str_remove("\\[[a-zA-Z0-9 -,.]*\\]") %>%
  str_remove("\\[od 2013M01, do 2012M12 Libijska arabska džamahirija\\]") %>% str_remove(",") %>%
  str_replace("Države in ozemlja ki niso navedena v okviru trgovine z državami nečlanicami","Ostale države") %>%
  str_replace("Srbija in Črna gora \\[2004M01 - 2005M05\\]","Jugoslavija")

UI.SLO[["DRZAVA"]] <- IU.SLO
return(UI.SLO)
}
uvoz.in.izvoz.Slovenije <- uvoz.in.izvoz()


#4. tabela
drzave.sveta <- function(){
url1 <- "https://www.worldometers.info/world-population/population-by-country/"
naslov1 <- read_html(url1)
podatki.drzav <- naslov1 %>% html_nodes(xpath="//table[@id='example2']") %>% 
  .[[1]] %>% html_table(dec=".") %>% select(2,3,7) %>% rename(Country=1,Population=2)

populacija.bv <- podatki.drzav$Population %>% str_replace_all(",","")
povrsina.bv <- podatki.drzav$`Land Area (Km²)` %>% str_replace_all(",","")  

podatki.drzav[["Population"]] <- populacija.bv
podatki.drzav[[3]] <- povrsina.bv

podatki.drzav$Population <- as.numeric(as.character(podatki.drzav$Population))
podatki.drzav$`Land Area (Km²)` <- as.numeric(as.character(podatki.drzav$`Land Area (Km²)`))

podatki.drzav.1 <- podatki.drzav %>% rename(drzava=1,populacija=2,povrsina=3)

return(podatki.drzav.1)
}
podatki.o.drzavah <- drzave.sveta()


#5.tabela
BDP.pkm <- function(){
  url2 <- "https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)_per_capita"
  naslov2 <- read_html(url2)
  BDP.ppp <- naslov2 %>% html_nodes(xpath="//table[@class ='wikitable sortable']") %>% 
    .[[1]] %>% html_table(dec=".") %>% rename(drzava=2,BDP=3) %>% select(2,3) 
    
  GDP.ppp1 <- BDP.ppp$drzava %>% str_replace("Côte d'Ivoire","Ivory Coast") %>% str_replace(", The","")
  GDP.ppp2 <- BDP.ppp$BDP %>% str_replace_all(",","") 
  BDP.ppp[["BDP"]] <- GDP.ppp2
  BDP.ppp$drzava <- GDP.ppp1
  BDP.ppp$BDP <- as.numeric(as.character(BDP.ppp$BDP))
  
  BDP.ppp1 <- BDP.ppp[-c(1,4),]
  
return(BDP.ppp1)
}
nominalni.BDP.per.capita <- BDP.pkm()