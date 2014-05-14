<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{An R Markdown Vignette made with knitr}
-->





helsinki - tutorial
===========

This R package provides tools to access open data from the Helsinki region in Finland
as part of the [rOpenGov](http://ropengov.github.io) project.

For contact information and source code, see the [github page](https://github.com/rOpenGov/helsinki). 

## Available data sources

[Helsinki region district maps](#aluejakokartat) (Helsingin seudun aluejakokartat)
* Aluejakokartat: kunta, pien-, suur-, tilastoalueet (Helsinki region district maps)
* Äänestysaluejako: (Helsinki region election district maps)
* Source: [Helsingin kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/)

Helsinki Real Estate Department (HKK:n avointa dataa)
* Spatial data from [Helsingin kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/) availabe in the [gisfin](https://github.com/rOpenGov/gisfin) package, see [gisfin tutorial](https://github.com/rOpenGov/gisfin/blob/master/vignettes/gisfin_tutorial.md) for examples

[Helsinki region environmental services](#hsy) (HSY:n avointa dataa)
* Väestötietoruudukko (population grid)
* Rakennustietoruudukko (building information grid)
* SeutuRAMAVA (building land resource information(?))
* Source: [Helsingin seudun ympäristöpalvelut, HSY](http://www.hsy.fi/seututieto/kaupunki/paikkatiedot/Sivut/Avoindata.aspx)

[Service and event information](#servicemap)
* [Helsinki region Service Map](http://www.hel.fi/palvelukartta/Default.aspx?language=fi&city=91) (Pääkaupunkiseudun Palvelukartta)
* [Omakaupunki](http://api.omakaupunki.fi/) (requires personal API key, no examples given)

[Helsinki Region Infoshare statistics API](#hri_stats)
* [Aluesarjat (original source)](http://www.aluesarjat.fi/) (regional time series data)
* More data coming...
* Source: [Helsinki Region Infoshare statistics API](http://dev.hel.fi/stats/)

[Economic data](#economy)
* [Taloudellisia tunnuslukuja](http://www.hri.fi/fi/data/paakaupunkiseudun-kuntien-taloudellisia-tunnuslukuja/) (economic indicators)

[Demographic data](#demography)
* [Väestöennuste 2012-2050](http://www.hri.fi/fi/data/helsingin-ja-helsingin-seudun-vaestoennuste-sukupuolen-ja-ian-mukaan-2012-2050/) (population projection 2012-2050)
 

List of potential data sources to be added to the package can be found [here](https://github.com/rOpenGov/helsinki/blob/master/vignettes/todo-datasets.md).

## Installation

Release version for general users:


```r
install.packages("helsinki")
```


Development version for developers:


```r
install.packages("devtools")
library(devtools)
install_github("helsinki", "ropengov")
```


Load package.


```r
library(helsinki)
```


## <a name="aluejakokartat"></a>Helsinki region district maps

Helsinki region district maps (Helsingin seudun aluejakokartat) and election maps (äänestysalueet) from [Helsingin kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/) are available in the helsinki package with `data(aluejakokartat)`. The data are available as both spatial object (`sp`) and data frame (`df`). These are preprocessed in the [gisfin](https://github.com/rOpenGov/gisfin) package, and more examples can be found in the [gisfin tutorial](https://github.com/rOpenGov/gisfin/blob/master/vignettes/gisfin_tutorial.md). 


```r
# Load aluejakokartat and study contents
data(aluejakokartat)
str(aluejakokartat, m = 2)
```

```
## List of 2
##  $ sp:List of 8
##   ..$ kunta            :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..$ pienalue         :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..$ pienalue_piste   :Formal class 'SpatialPointsDataFrame' [package "sp"] with 5 slots
##   ..$ suuralue         :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..$ suuralue_piste   :Formal class 'SpatialPointsDataFrame' [package "sp"] with 5 slots
##   ..$ tilastoalue      :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..$ tilastoalue_piste:Formal class 'SpatialPointsDataFrame' [package "sp"] with 5 slots
##   ..$ aanestysalue     :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##  $ df:List of 8
##   ..$ kunta            :'data.frame':	1664 obs. of  7 variables:
##   ..$ pienalue         :'data.frame':	33594 obs. of  7 variables:
##   ..$ pienalue_piste   :'data.frame':	295 obs. of  3 variables:
##   ..$ suuralue         :'data.frame':	6873 obs. of  7 variables:
##   ..$ suuralue_piste   :'data.frame':	23 obs. of  3 variables:
##   ..$ tilastoalue      :'data.frame':	17279 obs. of  7 variables:
##   ..$ tilastoalue_piste:'data.frame':	125 obs. of  3 variables:
##   ..$ aanestysalue     :'data.frame':	35349 obs. of  11 variables:
```



## <a name="hsy"></a> Helsinki region environmental services

Retrieve data from [Helsingin seudun ympäristöpalvelut (HSY)](http://www.hsy.fi/seututieto/kaupunki/paikkatiedot/Sivut/Avoindata.aspx) with `get_hsy()`.

### Population grid 

Population grid (väestötietoruudukko) with 250m x 250m grid size in year 2013 contains the number of people in different age groups. The most rarely populated grids are left out (0-4 persons), and grids wiht less than 99 persons are censored with '99' to guarantee privacy.


```r
sp.vaesto <- get_hsy(which.data = "Vaestotietoruudukko", which.year = 2013)
head(sp.vaesto@data)
```

```
##   INDEX ASUKKAITA ASVALJYYS IKA0_9 IKA10_19 IKA20_29 IKA30_39 IKA40_49
## 0   688         5        50     99       99       99       99       99
## 1   703         6        42     99       99       99       99       99
## 2   710         7        36     99       99       99       99       99
## 3   711         7        64     99       99       99       99       99
## 4   715        16        28     99       99       99       99       99
## 5   864        10        65     99       99       99       99       99
##   IKA50_59 IKA60_69 IKA70_79 IKA_YLI80
## 0       99       99       99        99
## 1       99       99       99        99
## 2       99       99       99        99
## 3       99       99       99        99
## 4       99       99       99        99
## 5       99       99       99        99
```



### Helsinki building information

Building information grid (rakennustietoruudukko) in Helsinki region on grid-level (500m x 500m): building counts (lukumäärä), built area (kerrosala), usage (käyttötarkoitus), and region
efficiency (aluetehokkuus).


```r
sp.rakennus <- get_hsy(which.data = "Rakennustietoruudukko", which.year = 2013)
head(sp.rakennus@data)
```

```
##   INDEX RAKLKM RAKLKM_AS RAKLKM_MUU KERALA_YHT KERALA_AS KERALA_MUU
## 0   688      3         2          1        324       282         42
## 1   691      3         2          1         90        80         10
## 2   692      9         4          5        286       206         80
## 3   702      2         2          0        262       262          0
## 4   703      3         2          1        373       326         47
## 5   710      6         2          4        370       302         68
##   KATAKER1  KATAKER2  KATAKER3 SUMMA1    SUMMA2    SUMMA3 ALUETEHOK
## 0       11       941 999999999    282        42 999999999  0.005288
## 1       41       941 999999999     80        10 999999999  0.001440
## 2       41       941       931    206        47        33  0.007304
## 3       11 999999999 999999999    262 999999999 999999999  0.004192
## 4       11       941 999999999    326        47 999999999  0.005968
## 5       11       931       941    302        39        29  0.005920
##   KATAKER1.description    KATAKER2.description    KATAKER3.description
## 0  Yhden asunnon talot       Talousrakennukset Puuttuvan tiedon merkki
## 1   Vapaa-ajan asunnot       Talousrakennukset Puuttuvan tiedon merkki
## 2   Vapaa-ajan asunnot       Talousrakennukset        Saunarakennukset
## 3  Yhden asunnon talot Puuttuvan tiedon merkki Puuttuvan tiedon merkki
## 4  Yhden asunnon talot       Talousrakennukset Puuttuvan tiedon merkki
## 5  Yhden asunnon talot        Saunarakennukset       Talousrakennukset
```


### Helsinki building area capacity

Building area capacity per municipal region (kaupunginosittain summattua tietoa rakennusmaavarannosta). Plot with number of buildlings with `spplot()`.


```r
sp.ramava <- get_hsy(which.data = "SeutuRAMAVA_tila", which.year = 2013)
head(sp.ramava@data)
```

```
##   KUNTA    KOKOTUN TILANRO            NIMI RAKLKM YKSLKM RAKEOIKEUS
## 0   049 0491013000     013 KILO-KARAKALLIO   2245    915    1871538
## 1   235 2351003000     003            <NA>    326    214     218052
## 2   049 0495051000     051 KANTA-KAUKLAHTI    952    396     321345
## 3   092 0926081000     081           KORSO   1511    965     519438
## 4   092 0927096000     096     ITÄ-HAKKILA    994    687     278428
## 5   049 0491014000     014     LAAKSOLAHTI   3749   1998     807561
##   KARA_YHT KARA_AS KARA_MUU RAKERA_YHT RAKERA_AS RAKERA_MUU VARA_YHT
## 0  1225666  607609   618057      40653     22814      17839   646923
## 1   171017  103585    67432       7411      6206       1205    47053
## 2   195116  144274    50842      41179     34061       7118    98379
## 3   419911  334123    85788       3963      3355        608    98692
## 4   193025  127626    65399       2067      1720        347    77453
## 5   600636  547178    53458      33286     29987       3299   174097
##   VARA_AS VARA_AP VARA_AK VARA_MUU VANHINRAKE UUSINRAKE OMLAJI_1
## 0   93878   68728   25150   553045       1900      2013       11
## 1   42653   40606    2047     4400       1907      2013       11
## 2   76698   72958    3740    21681       1900      2013        3
## 3   59018   54779    4239    39674       1890      2013        9
## 4   22339   22339       0    55114       1900      2013        9
## 5  135184  130252    4932    38913       1870      2013        9
##                        OMLAJI_1S OMLAJI_2                      OMLAJI_2S
## 0 Asunto-osakeyhtiö tai asunto-o       11 Asunto-osakeyhtiö tai asunto-o
## 1 Asunto-osakeyhtiö tai asunto-o       11 Asunto-osakeyhtiö tai asunto-o
## 2                          Espoo        3                          Espoo
## 3         Muu yksityinen henkilö        9         Muu yksityinen henkilö
## 4         Muu yksityinen henkilö        9         Muu yksityinen henkilö
## 5         Muu yksityinen henkilö        9         Muu yksityinen henkilö
##   OMLAJI_3                      OMLAJI_3S
## 0       11 Asunto-osakeyhtiö tai asunto-o
## 1       11 Asunto-osakeyhtiö tai asunto-o
## 2        3                          Espoo
## 3        9         Muu yksityinen henkilö
## 4        9         Muu yksityinen henkilö
## 5        9         Muu yksityinen henkilö
```

```r
# Values with less than five units are given as 999999999, set those to zero
sp.ramava@data[sp.ramava@data == 999999999] <- 0
# Plot number of buildings for each region
spplot(sp.ramava, zcol = "RAKLKM", main = "Number of buildings in each 'tilastoalue'")
```

![plot of chunk hsy_ramava](figure/hsy_ramava.png) 



## <a name="servicemap"></a>Service and event information

Function `get_servicemap()` retrieves regional service data from the new [Service Map API](http://api.hel.fi/servicemap/v1/), that retrieves data from the [Service Map](http://dev.hel.fi/servicemap/).


```r
# Search for 'puisto' (park) (specify q='query')
search.puisto <- get_servicemap(category = "search", q = "puisto")
# Study results
str(search.puisto, m = 1)
```

```
## List of 4
##  $ count   : num 1076
##  $ next    : chr "http://api.hel.fi/servicemap/v1/search/?q=puisto&page=2"
##  $ previous: NULL
##  $ results :List of 20
```

```r
# A lot of results found (count > 1000) Get names for the first 20 results
sapply(search.puisto$results, function(x) x$name$fi)
```

```
##  [1] "Asematien puisto"                  
##  [2] "Hurtigin puisto"                   
##  [3] "Kasavuoren puisto"                 
##  [4] "Kaupungintalon puisto"             
##  [5] "Stenbergin puisto"                 
##  [6] "Sinebrychoffin puisto"             
##  [7] "Sibeliuksen puisto"                
##  [8] "Hesperian puisto"                  
##  [9] "Kaisaniemen puisto"                
## [10] "Esplanadin puisto"                 
## [11] "Heiniitty, puisto"                 
## [12] "Ullanmäki, puisto"                 
## [13] "Puistot ja viheralueet"            
## [14] "Puistot ja viheralueet"            
## [15] "Säätytalon puisto, puistotäti"     
## [16] "Myllykallion puisto, puistotäti"   
## [17] "Teinintien puisto, puistotäti"     
## [18] "Esplanadin puiston WLAN-tukiasema" 
## [19] "Sibeliuksen puiston yleisövessa"   
## [20] "Sinebrychoffin puiston yleisövessa"
```

```r
# See what data is given for one service
str(search.puisto$results[[1]], m = 2)
```

```
## List of 26
##  $ connections              :List of 1
##   ..$ :List of 10
##  $ id                       : num 14461
##  $ data_source_url          : chr "http://www.kauniainen.fi"
##  $ name                     :List of 3
##   ..$ fi: chr "Asematien puisto"
##   ..$ en: chr "Playground"
##   ..$ sv: chr "Stationsvägens park"
##  $ description              : NULL
##  $ provider_type            : num 101
##  $ department               : chr "235-YKT"
##  $ organization             : num 235
##  $ street_address           :List of 3
##   ..$ fi: chr "Asematie 17"
##   ..$ en: chr "Asematie 17"
##   ..$ sv: chr "Stationsvägen 17"
##  $ address_zip              : chr "02700"
##  $ phone                    : NULL
##  $ email                    : NULL
##  $ www_url                  :List of 3
##   ..$ fi: chr "http://www.kauniainen.fi/palvelut_ja_lomakkeet/kadut_ja_viheralueet_liikenne/katujen_ja_yleisten_alueiden_kunnossapito/kaupungi"| __truncated__
##   ..$ en: chr "http://www.kauniainen.fi/palvelut_ja_lomakkeet/kadut_ja_viheralueet_liikenne/katujen_ja_yleisten_alueiden_kunnossapito/kaupungi"| __truncated__
##   ..$ sv: chr "http://www.kauniainen.fi/sv/service_och_blanketter/gator_och_gronomraden_trafik/underhall_av_gator_och_allmanna_omraden/stadens"| __truncated__
##  $ address_postal_full      : NULL
##  $ municipality             : NULL
##  $ picture_url              : NULL
##  $ picture_caption          : NULL
##  $ origin_last_modified_time: chr "2014-05-13T06:52:55.826Z"
##  $ connection_hash          : chr "fc36ea8ef1b2dce835aad80915454b60724059c3"
##  $ services                 : num [1:3] 28130 25394 25672
##  $ divisions                : list()
##  $ keywords                 : num [1:4] 838 837 4 1
##  $ root_services            : num [1:3] 25298 25622 28128
##  $ location                 :List of 2
##   ..$ type       : chr "Point"
##   ..$ coordinates: num [1:2] 24.7 60.2
##  $ object_type              : chr "unit"
##  $ score                    : num 2.19
```

```r
# More results could be retrieved by specifying 'page=2' etc.
```


Function `get_omakaupunki()` retrieves regional service and event data from the [Omakaupunki API](http://api.omakaupunki.fi/). However, the API needs a personal key, so no examples are given here.

## <a name="hri_stats"></a> Helsinki Region Infoshare statistics API

Function `get_hri_stats()` retrieves data from the [Helsinki Region Infoshare statistics API](http://dev.hel.fi/stats/). Note! The implementation will be updated!


```r
# Retrieve list of available data
stats.list <- get_hri_stats(query = "")
# Show first results
head(stats.list)
```

```
##                             Helsingin väestö äidinkielen mukaan 1.1. 
##                            "aluesarjat_a03s_hki_vakiluku_aidinkieli" 
##                                           Syntyneet äidin iän mukaan 
##                             "aluesarjat_hginseutu_va_vm04_syntyneet" 
##   Vantaalla asuva työllinen työvoima sukupuolen ja iän mukaan 31.12. 
##                             "aluesarjat_c01s_van_tyovoima_sukupuoli" 
## Espoon lapsiperheet lasten määrän mukaan (0-17-vuotiaat lapset) 1.1. 
##                            "aluesarjat_b03s_esp_lapsiperheet_alle18" 
##                                 Väestö iän ja sukupuolen mukaan 1.1. 
##                          "aluesarjat_hginseutu_va_vr01_vakiluku_ika" 
##         Helsingin asuntotuotanto rahoitusmuodon ja huoneluvun mukaan 
##                         "aluesarjat_a03hki_astuot_rahoitus_huonelkm"
```


Specify a dataset to retrieve. The output is currently a three-dimensional array.


```r
# Retrieve a specific dataset
stats.res <- get_hri_stats(query = stats.list[1])
# Show the structure of the results
str(stats.res)
```

```
##  num [1:22, 1:4, 1:197] 497526 501518 508659 515765 525031 ...
##  - attr(*, "dimnames")=List of 3
##   ..$ vuosi     : chr [1:22] "1992" "1993" "1994" "1995" ...
##   ..$ aidinkieli: chr [1:4] "Kaikki äidinkielet" "Suomi ja saame" "Ruotsi" "Muu kieli"
##   ..$ alue      : chr [1:197] "091 Helsinki" "091 1 Eteläinen suurpiiri" "091 101 Vironniemen peruspiiri" "091 10 Kruununhaka" ...
```


More examples to be added.

## <a name="economy"></a> Economic data

Function `get_economic_indicators()` retrieves [economic indicator](http://www.hri.fi/fi/data/paakaupunkiseudun-kuntien-taloudellisia-tunnuslukuja/) data for Helsinki, Espoo, Vantaa and Kauniainen from years 1998-2010. 


```r
# Retrieve data
ec.res <- get_economic_indicators()
# See first results
head(ec.res$data)
```

```
##       Alue                         Tunnusluku     1998     1999     2000
## 1 Helsinki                  Asukasluku 31.12. 546317.0 551123.0 555474.0
## 2 Helsinki               Tuloveroprosentti 1)     16.5     16.5     16.5
## 3 Helsinki     Verotettavat tulot, EUR/as. 2)  13856.0  14677.0  15512.0
## 4 Helsinki Verotettavien tulojen muutos, % 2)      6.8      7.3      6.6
## 5 Helsinki        Verotulot yhteensä, EUR/as.   3386.0   3336.0   3894.0
## 6 Helsinki           - Kunnallisvero, EUR/as.   2129.0   2187.0   2425.0
##       2001     2002     2003     2004     2005     2006     2007     2008
## 1 559718.0 559716.0 559330.0 559046.0 560905.0 564521.0 568531.0 574564.0
## 2     16.5     16.5     17.5     17.5     17.5     17.5     17.5     17.5
## 3  16077.0  16463.0  16424.0  16613.0  17111.0  17947.0  19022.0  19989.0
## 4      4.5      3.2     -0.2      1.1      2.9      5.2      6.7      5.8
## 5   4072.0   3556.0   3548.0   3448.0   3535.0   3709.0   3979.0   4199.0
## 6   2677.0   2860.0   2937.0   2863.0   2935.0   3096.0   3274.0   3437.0
##       2009 2010
## 1 583350.0   NA
## 2     17.5 17.5
## 3  19840.0   NA
## 4      0.3   NA
## 5   4120.0   NA
## 6   3477.0   NA
```



## <a name="demography"></a> Demographic data

Function `get_population_projection()` retrieves [population projection](http://www.hri.fi/fi/data/helsingin-ja-helsingin-seudun-vaestoennuste-sukupuolen-ja-ian-mukaan-2012-2050/) data for Helsinki and Helsinki region by age and gender.


```r
# Retrieve data
pop.res <- get_population_projection()
# See first results
head(pop.res$data[1:6])
```

```
##   Alue.Region Vuosi.Year Yhteensä.Total Miehet.Male   m0   m1
## 1    Helsinki       2011         588549      276361 3416 3049
## 2    Helsinki       2012         594483      279383 3364 3289
## 3    Helsinki       2013         599822      282099 3428 3231
## 4    Helsinki       2014         604561      284485 3487 3289
## 5    Helsinki       2015         609373      286899 3535 3348
## 6    Helsinki       2016         614246      289334 3577 3395
```



### Citation

**Citing the data:** See `help()` to get citation information for each data source individually.

**Citing the R package:**


```r
citation("helsinki")
```

```

Kindly cite the helsinki R package as follows:

  (C) Juuso Parkkinen, Leo Lahti and Joona Lehtomaki 2014.
  helsinki R package

A BibTeX entry for LaTeX users is

  @Misc{,
    title = {helsinki R package},
    author = {Juuso Parkkinen and Leo Lahti and Joona Lehtomaki},
    year = {2014},
  }

Many thanks for all contributors! For more info, see:
https://github.com/rOpenGov/helsinki
```


### Session info


This vignette was created with


```r
sessionInfo()
```

```
## R version 3.0.3 (2014-03-06)
## Platform: x86_64-apple-darwin10.8.0 (64-bit)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] knitr_1.5       helsinki_0.9.17 RCurl_1.95-4.1  bitops_1.0-6   
## [5] rjson_0.2.13    maptools_0.8-29 sp_1.0-14       roxygen2_3.1.0 
## 
## loaded via a namespace (and not attached):
##  [1] brew_1.0-6      codetools_0.2-8 digest_0.6.4    evaluate_0.5.1 
##  [5] foreign_0.8-60  formatR_0.10    grid_3.0.3      lattice_0.20-27
##  [9] Rcpp_0.11.1     stringr_0.6.2   tools_3.0.3
```

