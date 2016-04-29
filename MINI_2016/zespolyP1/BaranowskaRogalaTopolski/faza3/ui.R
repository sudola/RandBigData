library(shiny)
library(dplyr)
library(stringi)
library(png)
library(sciezkiCNK)
library(igraph)
library(ggplot2)

appTypes <- as.list(1:2)
names(appTypes)<- c("Dni w roku oraz godziny",  "Miesiące, dni tygodnia oraz godziny")
a <- "c"
shinyUI(fluidPage(
  titlePanel("Jak poruszamy się po ReGeneracji?"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "AppType",
                  label = "Wybierz jak chcesz agregować ścieżki",
                  choices = appTypes,
                  selected = 1),
      htmlOutput("SelektorDni"),
      htmlOutput("SelektorMiesiaca"),
      htmlOutput("SelektorMiesiacaCustom"),
      htmlOutput("SelektorDniaTygodnia"),
      htmlOutput("SelektorDniaTygodniaCustom"),
      sliderInput(inputId = "godzina", 
                  label = "Wybierz zakres godzin",
                  min = 9,
                  max = 20,
                  value = c(9,20),
                  step = 1,
                  round = TRUE),
      checkboxInput(inputId = "czySciezka",
                    label = "Zaznacz typową ścieżkę z wybranego okresu (czerwona)",
                    value = TRUE),
      checkboxInput(inputId = "czySciezkaAll",
                    label = "Zaznacz typową ścieżkę z całego roku (niebieska)",
                    value = TRUE),
      htmlOutput("SelektorDlugosciSciezki"),
      hr(),
      tags$div(class="header", checked=NA,
               tags$p("Wybrana stacja:")),
      htmlOutput("text"),
      htmlOutput("click")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("O mnie", {
          tags$div(class="header", checked=NA,
            tags$h1("Instrukcja obsługi"),
            tags$p("Autorzy: Ewa Baranowska, Zofia Rogala, Bartosz Topolski"),
            tags$p("Aplikacja służy do prezentacji ścieżek, po których poruszają się użytkownicy wystawy ReGeneracja w Centrum
                 Nauki Kopernik. Ścieżki zaznaczone są na mapie jako proste linie między eksponatami, przy czym
                   intensywność koloru ścieżku jest proporcjonalna do ilości użytkowników, którzy przeszli
                   między danymi eksponatami. Ponadto, na mapie może być też zaznaczona najbardziej prawdopodobna
                   droga, jaką obierze użytkownik wystawy podczas zwiedzania."),
            tags$p("Użytkownik ma do wyboru dwie opcje agregacji danych:"),
            tags$ul(
              tags$li("'Dni w roku oraz godziny' - pozwala na wybranie zakresu dni według dat (lub pojedynczego dnia).
                      "), 
              tags$li("'Miesiące, dni tygodnia oraz godziny' - pozwala na wybranie konkretnych miesięcy
                      i dni tygodnia.")),
            tags$p("Obie opcje pozwalają ponadto na wybór interesujących nas godzin."),
            tags$p("Wybierając agregację po dniach użytkownik ma do dyspozycji dwa elementy sterujące: wybór zakresu dni
                   w formie kalendarza oraz wybór zakresu godzin w formie suwaka. W przypadku, kiedy użytkownik poda pierwszą datę późniejszą niż drugą, aplikacja
                  automatycznie zamieni ich kolejność. "),
            tags$p("Wybierając agregację po miesiącach i dniach tygodnia użytkownik ma do dyspozycji dwie listy rozwijane:
                   jedna odpowiada za wybór dni tygodnia, druga za wybór miesiąca. Aplikacja zapewnia dostęp do kilku
                   predefiniowanych zakresów, dostępna jest też jednak opcja samodzielnego ustalenia tych wartości ('Custom').
                   Po jej wybraniu pojawia się lista checkboxów dla dni tygodnia, i suwak dla miesięcy. Tak 
                   jak poprzednio, dostępny jest również zakres godzin w formie suwaka."),
            tags$p("Przycisk 'Zaznacz typową ścieżkę z wybranego okresu' pozwala na rysowanie najbardziej prawdopodobnej drogi po wystawie
                   ReGeneracja podczas okresu wybranego za pomocą kontrolek. Droga ta będzie oznaczona strzałkami w czerwonym kolorze. Zaznaczając tą opcję, pojawia się
                   suwak odpowiadający za długość drogi, która zostanie narysowana."),
            tags$p("Przycisk 'Zaznacz typową ścieżkę z całego roku' pozwala na rysowanie najbardziej prawdopodobnej drogi po wystawie
                   ReGeneracja na podstawie danych z całego roku. Droga ta będzie oznaczona strzałkami w niebieskim kolorze. Jest ona 
                   niezależna od wybranych parametrów."),
            tags$p("Pod wszystkimi elementami sterującymi znajduje się pole zawierające informacje o
                   stacji, która zostanie kliknięta przez użytkownika. Pokazywane są takie informacje jak numer, nazwa oraz 3 najczęściej wybierane
                   kolejne stacje. Ponadto, po kliknięciu na stację na mapie zostają tylko ścieżki prowadzące z tej stacji, a typowa ścieżka
                   zaczyna się od tej stacji."),
            tags$p("Aby wyświetlić wykres, proszę przejść do zakładki 'Wykres'. Po każdej aktualizacji parametrów
                   wykres zostaje narysowany ponownie."),
            tags$p("Po klinięciu wybranej stacji, w zakładce 'Dane' pojawi się tabelka z prawdopodobieństwami przejścia z tej stacji do kolejnych."),
            tags$p("W zakładce 'Statystyki' znajdują się dane dotyczące rozkładu czasu i długości pojedynczego przejścia, prezentowane za
                   pomocą wykresów pudełkowych dla całego 2013 roku i dla wybranych dni. Obok wykresów podano średnie tych wielkości i
                   ilość wybranych dni.")
            )
          }
        ),
        tabPanel("Wykres", plotOutput("sciezki", hover = "plot_hover", click = "plot_click")),
        tabPanel("Dane", dataTableOutput("dataTable")),
        
        tabPanel("Statystyki", plotOutput("staty"))
      )
    )
  )
))