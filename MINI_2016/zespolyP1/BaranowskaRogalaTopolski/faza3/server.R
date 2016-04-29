weekdays <- as.list(c(2:7))
names(weekdays) <- c("Wtorek", "Środa", "Czwartek", "Piątek", "Sobota", "Niedziela")

weekdays_choices <- as.list(c(1:4))
names(weekdays_choices) <- c("Cały tydzień", "Wtorek - Piątek", "Sobota - Niedziela", "Custom")

months_choices <- as.list(c(1:3))
names(months_choices) <- c("Cały rok", "Wakacje (Lipiec - Sierpień)", "Custom")

data(dane_all)
data("doStatystyk")
data("slownik_urz")
data("mapka_png")
rownames(slownik_urz) <- slownik_urz$nr
slownik_urz %>% filter(x != 0) -> slownik_urz


shinyServer(function(input, output, session) {
   
  v <- reactiveValues(
     clicked = "---",
     top = NULL,
     str1 = NULL,
     str2 = NULL,
     dane_out = NULL
  )   
   
  AppType <- reactive({
    input$AppType
  })
  
  observeEvent(input$plot_click,{
    v$str1 <- findClosest(c(input$plot_click$x, 886 - input$plot_click$y), slownik_urz)[1]
    v$str2 <- findClosest(c(input$plot_click$x, 886 - input$plot_click$y), slownik_urz)[2]
    v$clicked <- stri_sub(findClosest(c(input$plot_click$x, 886 - input$plot_click$y), slownik_urz)[1],15,-1)
  })

  
  selectedWeekDays <- reactive({
     if(!is.na(AppType())){
       if(AppType() == 2){
         if(input$dzienTygodnia == 1) {return(2:7)}
         if(input$dzienTygodnia == 2) {return(2:5)}
         if(input$dzienTygodnia == 3) {return(6:7)}
         if(input$dzienTygodnia == 4 & !is.null(input$dzienTygodniaCustom)) {
           return(input$dzienTygodniaCustom)}
       }
       else {return(2:7)}
     }
  })
  
  selectedMonths <- reactive({
    if(!is.na(AppType())){
       if(AppType() == 2){
         if(input$miesiac == 1) {return(1:12)}
         if(input$miesiac == 2) {return(7:8)}
         if(input$miesiac == 3 & !is.null(input$miesiacCustom)) {return(input$miesiacCustom[1]:input$miesiacCustom[2])}
       }
       else {return(1:12)}
    }
  })
  
  selectedPathLength <- reactive({
    input$czySciezka
  })
  
  output$dataTable <- renderDataTable(v$dane_out, options = list(pageLength = 10))
  
  
  output$SelektorDni <- renderUI({
     
    if(!is.na(AppType())){
       if(AppType() == 1){
         dateRangeInput(inputId = "dzien", 
                        label = "Wybierz zakres dni",
                        start = "2013-01-01",
                        end = "2013-12-31",
                        min = "2013-01-01",
                        max = "2013-12-31",
                        weekstart = 1,
                        language = "pl",
                        separator = " do ")
       }
    }
  })
  
  output$SelektorDniaTygodnia <- renderUI({
     
     if(!is.na(AppType())){
       if(AppType() == 2){
         selectInput(inputId = "dzienTygodnia", 
                     label = "Wybierz zakres dni tygodnia",
                     choices = weekdays_choices,
                     selected = 1)
       }
     }
  })
  
  output$SelektorDniaTygodniaCustom <- renderUI({
     
     if(!is.na(AppType())){
       if(AppType() == 2){
          if(!is.null(input$dzienTygodnia)){
            if(input$dzienTygodnia == 4){
              checkboxGroupInput(inputId = "dzienTygodniaCustom", 
                                 label = "Wybierz dni tygodnia",
                                 choices = weekdays,
                                 selected = 2:7)
            }
          }
       }
     }
  })
  
  output$SelektorMiesiaca <- renderUI({
     
     if(!is.na(AppType())){
    if(AppType() == 2){
      selectInput(inputId = "miesiac", 
                  label = "Wybierz zakres miesięcy",
                  choices = months_choices,
                  selected = 1)
    }
     }
  })
  
  output$SelektorMiesiacaCustom <- renderUI({
     
     if(!is.na(AppType())){
       if(AppType() == 2){
          if(!is.null(input$miesiac)){
            if(input$miesiac == 3){
              sliderInput(inputId = "miesiacCustom", 
                          label = "Wybierz miesiące",
                          min=1,
                          max = 12,
                          value = c(1,12),
                          step = 1,
                          round = TRUE)
            }
          }
       }
     }
  })
  
  
  output$SelektorDlugosciSciezki <- renderUI({
     
     if(!is.na(AppType())){
    if(selectedPathLength()) {
      sliderInput(inputId = "dlugoscSciezki", 
                  label = "Wybierz długość ścieżki",
                  min = 7,
                  max = 35,
                  value = 10,
                  step = 1,
                  round = TRUE)
    }
     }
  })
  
  
  output$text <- renderUI({
    HTML(paste(v$str1, v$str2, sep = '<br/>'))
    
  })
  
  output$click <- renderUI({
     HTML(paste('<br/>', "Najczęstsze kolejne eksponaty:", v$top[1], v$top[2], v$top[3], sep = '<br/>'))
  })
  
  output$sciezki <- renderPlot({
     
    if(!is.null(AppType())){
       if(!is.null(input$godzina) & (AppType() == 1 | (!is.null(selectedWeekDays()) & !is.null(selectedMonths())) ) ){
       daty <- seq.Date(from = as.Date("2013-01-01"), to = as.Date("2013-12-31"), by = 1)
       if(AppType() == 2){
         filtr <- filter_data(weekdays = selectedWeekDays(), months = selectedMonths(), hours = input$godzina)
       }
       if(AppType() == 1){
         if(input$dzien[2]>= input$dzien[1]) {
           filtr <- filter_data_byday(days =input$dzien ,hours = input$godzina)
         }
         else filtr <- filter_data_byday(days = rev(input$dzien), hours = input$godzina)
       }
       filtr$from <- as.character(filtr$from)
       filtr$to <- as.character(filtr$to)
       sciezka_all <- sciezka(filter_data(), input$dlugoscSciezki, v$clicked) %>% filter(from %in% slownik_urz$nr, to %in% slownik_urz$nr)
       sciezka <- sciezka(filtr, input$dlugoscSciezki, v$clicked)
       sciezka <- sciezka %>% filter(from %in% slownik_urz$nr, to %in% slownik_urz$nr)
       top <- 8
       
       rownames(slownik_urz) <- slownik_urz$nr
       if(v$clicked != "---"){
         filtr[filtr$from != v$clicked ,"total"] <- 0
         v$dane_out <- filtr %>% 
            filter(total>0, to != "---") %>% arrange(desc(total)) %>%
            transmute(stacja = as.character(to), 
                      p = paste0(round(total/sum(total)*100,2)," %"), 
                      nazwa = slownik_urz[as.character(to), "nazwa"], 
                      kategoria = slownik_urz[as.character(to), "kategoria"],
                      total = total) %>% 
            select(stacja, nazwa, kategoria, p, total)
         top <- 2
         a <- filtr$to[order(filtr$total, decreasing = TRUE)[1:4]]
         a <- a[a != "---"]
         v$top <- a
       }
       else {
          v$top <- NULL
          v$dane_out <- NULL
       }
       
       if(max(filtr$total)!=0){
         filtr$total <- filtr$total / sort(filtr$total, decreasing = T)[top]
       }
       filtr$total[filtr$total>1] <- 1
       filtr$total <- filtr$total^1.3
       rozmiary <- plot_mapa(mapka_png, obram=F)
       plot_paths2(filtr, slownik_urz, col = "#160773")
       
       if(input$czySciezka){
         plot_polaczenia_graph(data = sciezka , 
                               slownik = slownik_urz, 
                               alpha = 0.5, 
                               czyStrzalki = T, 
                               szerStrzalek = 2, 
                               kolLinii = "#bf1010", 
                               rozmiarStrzalek = 1 )
       }
       if(input$czySciezkaAll){
         plot_polaczenia_graph(data = sciezka_all , 
                                slownik = slownik_urz, 
                                alpha = 0.5, 
                                czyStrzalki = T, 
                                szerStrzalek = 2, 
                                kolLinii = "blue", 
                                rozmiarStrzalek = 1,
                                krzywLinii = -0.2)
       }
       plot_urzadz(slownik_urz, col = "#3a2e85", cex=3.7)
       plot_etykiety_nr(slownik_urz, przes= c(0,0), cex = 0.9)
       }
    }
   }
   , height = 900, width = 800)
  
  output$staty <- renderPlot({
     
     if(!is.null(AppType())){
        if(!is.null(input$godzina) & (AppType() == 1 | (!is.null(selectedWeekDays()) & !is.null(selectedMonths())) ) ){
           daty <- seq.Date(from = as.Date("2013-01-01"), to = as.Date("2013-12-31"), by = 1)
           if(AppType() == 2){
              filtr <- wybraneDni_filter_data(weekdays = selectedWeekDays(), months = selectedMonths())
           }
           if(AppType() == 1){
              if(input$dzien[2]>= input$dzien[1]) {
                 filtr <- wybraneDni_filter_data_byday(days =input$dzien)
              }
              else filtr <- wybraneDni_filter_data_byday(days = rev(input$dzien))
           }
           
           rysujBoxploty(filtr)
           
           
        }
     }
  }
  , height = 600, width = 1200)
})