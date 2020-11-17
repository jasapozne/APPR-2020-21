# Analiza podatkov s programom R, 2020/21

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2020/21

* [![Shiny](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jasapozne/APPR-2020-21/master?urlpath=shiny/APPR-2020-21/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/jasapozne/APPR-2020-21/master?urlpath=rstudio) RStudio

## Analiza uvoza in izvoza v Sloveniji

Z analizo slovenskega uvoza in izvoza skozi časovno obdobje razpona 10 let, bom poskušal ugotoviti iz katerih držav največ uvozimo in izvozimo, katere so te dobrine ter kako se je to skozi leta spreminjalo. Dodatno me bo še zanimalo, kakšen je vpliv uvoza in izvoza na BDP ter kakšen je ta doprinos v premerjavi z ostalimi državami EU. Na zadnje bom Slovenijo uvrstil v podskupino z državami, ki bodo imele približno enak saldo menjave dobrin, ter potem analiziral kako se Slovenija primerja z ostalimi svetovnimi državami iz te podskupine po BDP ppp.Probal bom ugotoviti ali Slovenija sploh ima strateško partnerico, na koncu pa bom še pogledal kako se Slovenija primerja z ostalimi državami pa izvozu in uvozu, ki imajo približno enako število prebivalcev ter površino.

- 1. tabela: Uvoza in izvoz blaga po SMTK (letno) - države, blago (izvoz/uvoz), leta 

- 2. tabela: Izdatkovna struktura BDP (letno) - saldo menjave, leta 

- 3. tabela: Doprinos uvoza iz izvoza k BDP v EU - doprinos uvoza in izvoza, leta, države

- 4. tabela: BDP ppp- države, BDP ppp, leta

- 5. in vi. tabela: Količinski uvoz in izvoz držav - države, izvoz, uvoz, saldo, leta

- 7. tabela: Tabela držav in njihovih značilnosti- države, populacija, površina države 

Podatkovni viri:
Za projekt bom uporabil podatke iz:
- SURS:https://pxweb.stat.si/SiStat/sl/Podrocja/Index/141/trgovina-in-storitve v CSS

- EUROSTAT:https://ec.europa.eu/eurostat/search?p_auth=QM2IBzz7&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_theme=empty&_estatsearchportlet_WAR_estatsearchportlet_action=search&_estatsearchportlet_WAR_estatsearchportlet_collection=empty&text=imports+and+exports v CSS

- Wikipedia: https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(PPP)_per_capita v XML

- IMF: https://data.imf.org/regular.aspx?key=61013712 v XML

- worldometer:https://www.worldometers.info/world-population/population-by-country/ v XML
## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `rgeos` - za podporo zemljevidom
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `tidyr` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `tmap` - za izrisovanje zemljevidov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-202021)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
