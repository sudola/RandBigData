library(cnk)
library(scales)



shinyServer(function(input, output, session) {
    
    # Zmienne globalne:
    usr <- NULL   # parametr usr zwracany przez funkcję par()
    cala_sciezka <- NULL
    srodowisko <- environment()
    
    
    bliskieEskponaty <- reactive({
        sort(pstwa[input$wybranyEksponat, ], decreasing = TRUE)[1:input$suwak]
    })
    
    # Zakładka tabela
    output$Tabela = renderDataTable({
        eksponaty <- bliskieEskponaty()
        tab <- data.frame(names(eksponaty),
                          pelne_nazwy[names(eksponaty)], percent(eksponaty))
        colnames(tab) <- c("id","nazwa","prawdopobieństwo")
        tab
    }, options = list(searching=FALSE, paging = FALSE, dom = 'ft', ordering = FALSE))
    
    
    # Zakładka wykres
    output$wykres = renderPlot({
        wykres(bliskieEskponaty(), input$wybranyEksponat)
    })
    
    observeEvent(input$klik, {
        reaguj.wykres(bliskieEskponaty(), input$klik, session)
    })
    
    
    # Zakładka eksponaty
    output$mapa <- renderPlot({
      mapka1(input$wybranyEksponat, names(bliskieEskponaty()), eksponaty,
             wspX, wspY, img, srodowisko, usr)
      dodaj_info(input$wybranyEksponat,pelne_nazwy[input$wybranyEksponat])
    })
    
    
    observeEvent(input$klik_mapa, {
        reaguj.mapa(eksponaty, input$klik_mapa, wspX, wspY, 
                     srodowisko, session, usr)
    })
    
    
    # Zakładka scieżki
    observeEvent(input$wybranyEksponat, {
        cala_sciezka <<- generuj.sciezke(input$wybranyEksponat, 45, pstwa)
    })
    
    
    output$mapa2 <- renderPlot({
        wybrany <- input$wybranyEksponat
        sciezka <- cala_sciezka[1:input$suwak]
        mapka2(wybrany, sciezka, eksponaty, wspX, wspY, img, srodowisko, usr)
    })
    
    observeEvent(input$klik_mapa2, {
        reaguj.mapa(eksponaty, input$klik_mapa2, wspX, wspY, 
                    srodowisko, session, usr)
    })
    
})


