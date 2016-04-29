library(shiny)
library(cnk)

eksponaty <- rownames(pstwa)

shinyUI(fluidPage(
  tags$head(tags$style(HTML("
                            .well {
                            width: 300px;
                            }
                            "))),
  titlePanel("Przepływ odwiedzających przez wystawę Re: generacja"),
  h5("Grzegorz Bajor, Aleksandr Panimash, Michał Restak, Michał Stolarczyk"),
  br(),
  sidebarLayout(
    sidebarPanel(
      selectInput("wybranyEksponat", 
                  label = "Wybierz eksponat",
                  choices = eksponaty,
                  selected = "cnk02a"),
      sliderInput("suwak", "Wybierz liczbę eksponatów", 
                  min = 1, max = 45, value = 10, step = 1),
      
      conditionalPanel('input.dataset === "Tabela"',
                       p("Tabela przedstawia prawdopobieństwa przejścia w jednym kroku
                         z wybranego urządzenia"),
                       p("Suwakiem można zmienić liczbę wyświetlanych najprawdopodobniejszych eksponatów")
      ),
      conditionalPanel('input.dataset === "Wykres"',
                       p("Wykres przedstawia prawdopodobieństwa przejścia w jednym kroku
                         z wybranego urządzenia"),
                       p("Po kliknięciu na słupek zostaniemy przekierowani do kolejnego eksponatu"),
                       p("Suwakiem można regulować liczbę wyświetlanych eksponatów")
      ),
      conditionalPanel('input.dataset === "Eksponaty"',
                       p("Punkty na mapie reprezentują umiejscowienie eksponatu"),
                       p("Wielkość punktów odzwierciedla częstość przejścia z wybranego eksponatu do kolejnego"),
                       p("W lewym dolnym rogu mapy wyswietla się pełna nazwa wybranego eksponatu"),
                       p("Po naciśnięciu punktu zostaniemy przekierowani do kolejnego eksponatu"),
                       p("Suwakiem można regulować liczbę wyróżnionych najpopularniejszych eksponatów")
      ),
      conditionalPanel('input.dataset === "Ścieżki"',
                       p("Punkty na mapie reprezentują umiejscowienie eksponatu"),
                       p("Na mapie znajduje się typowa ścieżka startująca z wybranego eksponatu"),
                       p("Po naciśnięciu punktu zostaniemy przekierowani do kolejnego eksponatu"),
                       p("Suwakiem można regulować długość ścieżki")
      )
    ),
    mainPanel(
      tabsetPanel(
        
        id = 'dataset',
        
        tabPanel("Tabela", 
                 h4("Prawdopodobieństwa przejscia dla wybranego eksponatu"), 
                 dataTableOutput("Tabela")),
        tabPanel("Wykres",
                 h4("Prawdopodobieństwa przejscia dla wybranego eksponatu"),
                 plotOutput("wykres", click = "klik")),
        tabPanel("Eksponaty", 
                 h4("Najbardziej prawdopodobne eksponaty w kolejnym kroku"),
                 plotOutput("mapa", click = "klik_mapa", 
                            width = 650, height = 500)),
        tabPanel("Ścieżki", 
                 h4("Typowe ścieżki startujące z wybranego eksponatu"),
                 plotOutput("mapa2", click = "klik_mapa2",
                            width = 650, height = 500)),
        selected = "Eksponaty"
      )
    )
  )
  ))