library(ggplot2)
library(stringi)
library(DT)
library(dplyr)
library(grupa0Faza3)
#="UTF-8",to="Windows 1250"))


shinyServer(function(input, output, session) {
   
   
   output$pop <- renderPlot({
      
      if(input$p_ramka=="ciekawe"){ 
         wykres_popularna(popularne_ciekawe, in_data=input$p_data,
                          in_miesiac_rok=NA)
      }
      else {
         p_miesiac <-stri_extract_first_regex( input$p_data_kal, "(?<=-)[\\p{N}]{2}(?=-)" ) 
         p_rok <- stri_extract_first_regex( input$p_data_kal, "[\\p{N}]{4}(?=-)" ) 
         p_datamc<-paste0( p_rok,"-",p_miesiac )
         
         wykres_popularna(popularne_miesiac, in_data=NA,
                          in_miesiac_rok=p_datamc) 
      }
   })
   output$ppt <- renderDataTable({
      # tabela danych
      
      if(input$p_ramka=="ciekawe"){ 
         tabela_popularna(popularne_ciekawe, in_data=input$p_data,
                          in_miesiac_rok=NA)
      }
      else {
         p_miesiac <- stri_extract_first_regex( input$p_data_kal, "(?<=-)[\\p{N}]{2}(?=-)" ) 
         p_rok <-  stri_extract_first_regex( input$p_data_kal, "[\\p{N}]{4}(?=-)" ) 
         p_data<-paste0( p_rok,"-",p_miesiac )
         
         tabela_popularna(popularne_miesiac, in_data=NA,
                          in_miesiac_rok=p_data) 
      }
   }, options = list(dom="tp"))
   
   output$cz <- renderPlot({
      # tabela danych aktywnosci
      
      c_miesiac <- as.numeric( stri_extract_first_regex( input$c_data_kal, "(?<=-)[\\p{N}]{2}(?=-)" ) )
      c_rok <- as.numeric( stri_extract_first_regex( input$c_data_kal, "[\\p{N}]{4}(?=-)" ) )
      
      wykres_czasow_typowej_sciezki(podaj_rok=c_rok, podaj_miesiac=c_miesiac,
                                    rodzaj_miary = input$c_miara)
   })
   output$ak <- renderPlot({
      # tabela danych aktywnosci
      
      a_miesiac <- as.numeric( stri_extract_first_regex( input$a_data_kal, "(?<=-)[\\p{N}]{2}(?=-)" ) )
      a_rok <- as.numeric( stri_extract_first_regex( input$a_data_kal, "[\\p{N}]{4}(?=-)" ) )
      
      wykres_aktywnosc(podaj.typ=input$a_typ, podaj.rok=a_rok, 
                       podaj.miesiac=a_miesiac, podaj.czesc=input$a_czesc)
   })
   output$akt <- renderDataTable({
      a_miesiac <- as.numeric( stri_extract_first_regex( input$a_data_kal, "(?<=-)[\\p{N}]{2}(?=-)" ) )
      a_rok <- as.numeric( stri_extract_first_regex( input$a_data_kal, "[\\p{N}]{4}(?=-)" ) )
      
      tabela_aktywnosc(podaj.typ=input$a_typ, podaj.rok=a_rok, 
                       podaj.miesiac=a_miesiac, podaj.czesc=input$a_czesc)
   }, options = list(dom="tp"))
   
   output$sk <- renderPlot({
      # tabela danych pierwsze
      s_miesiac <- as.numeric( stri_extract_first_regex( input$s_data_kal, "(?<=-)[\\p{N}]{2}(?=-)" ) )
      s_rok <- as.numeric( stri_extract_first_regex( input$s_data_kal, "[\\p{N}]{4}(?=-)" ) )
      
      wykres_skrajne(podaj.kolejnosc=input$s_kolejnosc, podaj.rok=s_rok, 
                     podaj.miesiac=s_miesiac, podaj.czesc.tyg=input$s_czesc)
   })
   output$skt <- renderDataTable({
      s_miesiac <- as.numeric( stri_extract_first_regex( input$s_data_kal, "(?<=-)[\\p{N}]{2}(?=-)" ) )
      s_rok <- as.numeric( stri_extract_first_regex( input$s_data_kal, "[\\p{N}]{4}(?=-)" ) )
      
      tabela_skrajne(podaj.kolejnosc=input$s_kolejnosc, podaj.rok=s_rok, 
                     podaj.miesiac=s_miesiac, podaj.czesc.tyg=input$s_czesc)
   }, options = list(dom="tp"))
   
   
   output$ht <- renderPlot({
      # tabela danych liczebnosci_sc
      if(input$h_grupa=="rok"){
         hist_sciezek(podaj.grupe="rok", podaj.rok=input$h_rok, podaj.czesc.tyg=NA,
                      podaj.typ=input$h_typ)
      }
      else{
         hist_sciezek(podaj.grupe="czesc_tyg", podaj.rok=NA, 
                      podaj.czesc.tyg=input$h_czesc, podaj.typ=input$h_typ)
      }
   })
   
   output$dt <- renderPlot({
      # tabela danych liczebnosci_sc
      if(input$h_grupa=="rok"){
         dystrybuanta_sciezek(podaj.grupe="rok", podaj.rok=input$h_rok, podaj.czesc.tyg=NA)
      }
      else{
         dystrybuanta_sciezek(podaj.grupe="czesc_tyg", podaj.rok=NA, 
                              podaj.czesc.tyg=input$h_czesc)
      }
   })
   
})