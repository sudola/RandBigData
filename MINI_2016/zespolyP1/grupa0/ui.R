library(shiny)
library(stringi)
library(dplyr)
library(grupa0Faza3)
library(DT)


#przy pracy na Windows'ie trzeba kodowanie zmienic
#sciezka_eksponat$dzien_tyg <-suppressWarnings(stri_encode(sciezka_eksponat$dzien_tyg,from="UTF-8",to="Windows 1250"))




lista_data<-as.character(popularne_ciekawe$data)

lista_mcrok<-unique(as.character(popularne_miesiac$miesiac_rok))
lista_mcrok<-lista_mcrok[-36]


shinyUI(fluidPage(
   
   titlePanel("Analiza ścieżek odwiedzających Centrum Nauki Kopernik"),
   sidebarLayout(
      sidebarPanel(
        conditionalPanel(' input.dataset === "Histogram ścieżek"',
                         radioButtons("h_grupa", "Wybór grupy zbioru danych:", selected="rok",
                                      c("rok", "część tygodnia"="czesc_tyg")),
                         conditionalPanel(condition = 'input.h_grupa=="rok"',
                                          checkboxGroupInput("h_rok", "Wybór roku:", selected="2012",
                                            choices=c("2012", "2013", "2014", "2015"))
                                          ),
                         conditionalPanel(condition = 'input.h_grupa=="czesc_tyg"',
                                          checkboxGroupInput("h_czesc", "Wybór części tygodnia:", 
                                                             selected="dni_robocze",
                                                             choices=c("dni robocze"="dni_robocze", "weekend"))
                         ),
                         radioButtons("h_typ", "Wybór typu:", selected="liczebnosci",
                                      c("liczebności"="liczebnosci", "częstości"="czestosci")),
                         
                         p("Histogram przedstawia rozkład liczby ścieżek. Nie uwzględniono
                                  logowań krótszych niż 5 s. W przypadku histogramu dla dwóch wartości
                                  grupy, kolor nie występujący w legendzie jest mieszaniną kolorów z legendy.
                                  Można porównywać jedynie dwa dowolne lata ze zbioru danych.",
                                  
                                  "Na wykresie poniżej histogramu przedstawiona jest empiryczna dystrybuanta
                                  rozkładu liczby ścieżek dla tych samych danych.")
                         #sliderInput("k_rok", "Wybór roku:",
                         #min=2012, max=2015, value=c(2012, 2013,2014, 2015), 
                         #step=1, sep="")
        ),
        conditionalPanel('input.dataset === "Popularne"',
                         radioButtons("p_ramka", "Wybór zbioru danych:", 
                                     c("ciekawe", "comiesięczne")),
                         conditionalPanel(condition = 'input.p_ramka=="ciekawe"',
                                          selectInput("p_data", "Wybór daty:", 
                                                      choices=lista_data, selected = "2013-02-03" )
                                          ),
                         conditionalPanel(condition = 'input.p_ramka=="comiesięczne"',
                                          dateInput("p_data_kal","Wybór daty:", value= lista_mcrok, format="mm-yyyy",
                                                    min="2012-01-01", max="2015-10-31", startview = "year")
                                          #selectInput("p_mscrok", "Wybór rok i miesiąca:", 
                                          #           choices=lista_mcrok,selected = lista_mcrok[1] )
                                          ),
                         h3("Opis danych"),
                         p("Popularne - zakładka poświęcona popularnej ścieżce w CNK. 
                                  Co to jst popularna ścieżka? Jest to ścieżka, która powstaje 
                                  w następujący sposób: bierzemy eksponaty ze wszystkich ścieżek, 
                                  które były odwiedzone jako pierwsze i wyznaczamy ten eksponat 
                                  (lub eksponaty), który był odwiedzany najczęściej. Następnie 
                                  powtarzamy tą procedurę, ale dla eksponatów, które były 
                                  odwiedzane jako drugie w kolejności i również wybieramy te 
                                  eksponaty, które były odwiedzane najczęściej, itd."),

                                  p("Po prawej stronie mamy do wyboru czy chcemy zobaczyć popularne 
                                  ścieżki ze wszystkich miesiecy w danym roku, czy może przyjrzeć 
                                  się kilku ciekawym ścieżkom z konkretnych dni z lat 2012-2015. 
                                  Po dokonaniu wyboru pokaże nam się lista z możliwymi datami do wyboru."),
                         
                                  p("Obok przedstawiony jest wykres, który przedstawia popularną ścieżkę.
                                  Na osi odciętych mamy nazwy eksponatów, zaś na osi rzędnych
                                  mamy numer, jaki dany eksponat miał w ścieżce (kolejność).
                                  Pod wykresem mamy dodatkowo tabelę, która mówi nam, ile było
                                  popularnych eksponatów na poszczególnych miejscach odwiedzin.
                                  Tabela zawiera również procent liczby odwiedzających, którzy
                                  na k-tym miejscu w swojej ścieżce podeszli do danego eksponatu.")
        ),
        conditionalPanel('input.dataset === "Czasy typowej ścieżki"',
                         #sliderInput("c_rok", "Wybór roku:", 
                         #            min=2012, max=2015, value=2012, sep=""),
                         #sliderInput("c_miesiac", "Wybór miesiąca:",
                         #            min = 1, max = 12, value=1, step=1),
                         
                         dateInput("c_data_kal","Wybór daty:", value= lista_mcrok, format="mm-yyyy",
                                   min="2012-01-01", max="2015-10-31", startview = "year"),
                         
                         radioButtons("c_miara", "Wybór cechy:",
                                      c("średnia"="srednia", "mediana"),selected = "mediana"),
                         h3("Opis danych"),
                         p("Obok przedstawiony jest wykres mediany lub średniej czasów (do wyboru), 
                                    który spędzili wszyscy użytkownicy mający ścieżkę długości co najmniej 20 
                                    w wybranym przedziale czasu przy kolejnym eksponacie występującym w ścieżce. 
                                    Uwzględniony został podział na weekend i dni robocze. Za dni robocze uznawane są wtorek, 
                                    środa, czwartek oraz piątek. Na osi odciętych znajdują się numery kolejnych eksponatów, 
                                    natomiast na osi rzędnych czas w sekundach. "),
                                    p("Możemy zauważyć, że w weekend odwiedzający spędzają średnio więcej czasu przy 
                                    eksponatach niż w dni robocze.")
        ),
         conditionalPanel('input.dataset === "Aktywność"',
                          radioButtons("a_typ", "Wybór typu:", selected="najbardziej",
                                      c("najbardziej", "najmniej")),
                         # sliderInput("a_rok", "Wybór roku:", 
                         #             min=2012, max=2015, value=2012, sep=""),
                          
                          dateInput("a_data_kal","Wybór daty:", value= lista_mcrok, format="mm-yyyy",
                                    min="2012-01-01", max="2015-10-31", startview = "year"),
                          
                          #sliderInput("a_miesiac", "Wybór miesiąca:",
                          #            min = 1, max = 12, value=1, step=1),
                          checkboxGroupInput("a_czesc", "Wybór części tygodnia:", selected="weekend",
                                        choices=c("dni robocze", "weekend")),
                                   
                          h3("Opis danych"),
                          p("Na wykresie obok pokazywane są najbardziej/najmniej aktywne
                                   eksponaty w zależności od długości (liczby eksponatów) ścieżki.
                                   Przez aktywność rozumiany jest sumaryczny czas pracy eksponatu,
                                   gdy była w nim włożona karta odwiedzającego. Pomija się ścieżki
                                   dłuższe od 40-elementowych. Nie uwzględniono logowań krótszych niż
                                   5 s oraz eksponatów nieużywanych."),
                                   
                                   p("W tabeli zestawiono natomiast wszystkie ścieżki oraz mające więcej
                                   niż 3 eksponaty ekstremalne. Dlatego podawana jest liczba ekstremalnych
                                   eskponatów. W tabeli podano również sumaryczny czas w minutach oraz 
                                   udział procentowy w sumie wszystkich czasów w danej ścieżce.")
         ),
         conditionalPanel('input.dataset === "Skrajne"',
                          radioButtons("s_kolejnosc", "Wybór typu:", selected="pierwszy",
                                       c("pierwszy", "ostatni")),
                          
                          dateInput("s_data_kal","Wybór daty:", value= lista_mcrok, format="mm-yyyy",
                                    min="2012-01-01", max="2015-10-31", startview = "year"),
                          
                          #sliderInput("s_rok", "Wybór roku:", 
                           #             min=2012, max=2015, value=2012, sep="",dragRange=FALSE),
                          #sliderInput("s_miesiac", "Wybór miesiąca:",
                           #           min = 1, max = 12, value=1, step=1),
                          checkboxGroupInput("s_czesc", "Wybór części tygodnia:", selected="weekend",
                                        choices=c("dni robocze", "weekend")),
                          h3("Opis danych"),
                          p("Na wykresie obok pokazywane są najczęstsze pierwsze/ostatnie
                                   eksponaty w zależności od długości (liczby eksponatów) ścieżki. 
                                   Pomija się te długości ścieżek, dla których obserwuje się więcej
                                    niż 3 eksponaty ekstremalne oraz dłuższe od 40-elementowych.
                                   Również pominięto w analizie logowania krótsze niż 5 s."),
                                   
                                   p("W tabeli zestawiono natomiast wszystkie ścieżki oraz mające więcej
                                   niż 3 eksponaty ekstremalne. Dlatego podawana jest liczba ekstremalnych
                                   eksponatów. W tabeli podano również liczba odwiedzającyh oraz 
                                   udział procentowy w sumie wszystkich odwiedzającyh w danej ścieżce.")
         )
         
      ),
      mainPanel(
         tabsetPanel(
            id = 'dataset',
            tabPanel("Histogram ścieżek",
                     plotOutput("ht"),
                     plotOutput("dt")
            ),
            tabPanel("Popularne",
                     plotOutput("pop"),
                     dataTableOutput("ppt")
            ),
            tabPanel("Czasy typowej ścieżki",
                     plotOutput("cz")
            ),
            tabPanel("Aktywność",
                     plotOutput("ak"),
                     dataTableOutput("akt")
            ),
            tabPanel("Skrajne",
                     plotOutput("sk"),
                     dataTableOutput("skt")
            )
            
            )
            
         )
      )
   )
)