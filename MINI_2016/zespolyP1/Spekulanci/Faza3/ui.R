library(shiny)
library(stringi)


library(dplyr)
library(RSQLite)

sterownik <- dbDriver("SQLite")
polaczenie <- dbConnect(sterownik, "maly.db")
con = dbConnect(sterownik, "maly.db")
nazwy <- dbGetQuery(con,"Select * from nazwy")
dni_tygodnia <- dbGetQuery(con,"Select distinct(weekday) from gestosc")
dni_tygodnia[7,1]="wszystkie"
shinyUI(fluidPage(
   
   titlePanel("Analiza ścieżek po ReGeneracji"),
   sidebarLayout(
      sidebarPanel(
         conditionalPanel('input.dataset === "Ogólne informacje"',
                          helpText("Aplikacja jest rozszerzeniem raportu, dotyczącego analizy danych z eksponatów w Centrum Nauki Kopernik."),helpText("Autorzy:"),p("Michał Muck"),p("Rafał Grądziel"),p("Rafał Rutkowski"),p("Robert Trąbczyński")
         ),
         conditionalPanel('input.dataset === "Eksponaty"',
                          selectInput("eksponat", "Lista eksponatów:", 
                                      choices=nazwy$name,selected =nazwy$name[1] ),
                          selectInput("dzien_tyg", "Wybierz dzień tygodnia:", selected = "wszystkie",
                                      choices=dni_tygodnia),
                          sliderInput("zakres_godzin", 
                                      label = "Zakres godzin:",
                                      min = 0, max = 24, value = c(0, 24))
         ),
         conditionalPanel(' input.dataset === "Ścieżki"',
                          selectInput("eksponat2", "Wybierz eksponat przez który bedą przechodzić ścieżki:", 
                                      choices=nazwy$name,selected =nazwy$name[1] ),
                          radioButtons("popularnosc", label = h3("Popularność:"),
                                       choices = list("Duża" = 1, "Mała" = 2),selected = 1)
         )
         
         
      ),
      mainPanel(
         tabsetPanel(
            id = 'dataset',
            tabPanel( "Ogólne informacje",
                      p("Dane na których przeprowadziliśmy naszą analizę pochodzą z Centrum Nauki Kopernik z lat 2012-2015."),
                      p("W zakładce 'Ścieżki' po wybraniu eksponatu oraz interesującej nas popularności, naniesione na wykres zostaną najbardziej/najmniej popularne ścieżki dla wybranego eksponatu."),
                      p("W zakładce 'Eksponaty' po wybraniu dnia oraz zakresu godzin, zaznaczone zostaną kropki w miejscu eksponatów o wielkościach odpowiadających liczbie odwiedzin danego stanowiska."),
                      div(img(src="cnk.jpg", height = 400, width =400), style="text-align: center;")
            ),
            tabPanel("Ścieżki",
                     p("Na mapkę naniesione zostały najbardziej lub najmniej popularne ścieżki dla wybranego eksponatu.", style="text-align: center;"),
                     plotOutput("sciezki"),
                     p(""),
                     dataTableOutput("tabelka2")
            ),
            tabPanel("Eksponaty",
                     p("Liczba niepowtarzających się odwiedzin, korzystając z macierzy przejścia.", style="text-align: center;"),
                     plotOutput("map"),
                     br(""),
                     p("W tabelce poniżej umieszczonych zostało 5 najczęściej pojawiających się eksponatów przy zadanych warunkach."),
                     dataTableOutput("tabelka")
            )
            
         )
      )
   )
))