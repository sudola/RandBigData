library(png)
library(stringi)
library(dplyr)
library(RSQLite)

sterownik <- dbDriver("SQLite")
polaczenie <- dbConnect(sterownik, "maly.db")
dbListTables(polaczenie)
con = dbConnect(sterownik, "maly.db")


gestosc <- dbGetQuery(con,"Select * from gestosc")
wsp <- read.csv("wspolrzedne.csv")
wsp <- wsp[1:59,]
plan<-readPNG("plan.png")
nazwy <- dbGetQuery(con,"Select * from nazwy")
wspolrzedne <- data.frame("code"=nazwy$code,"name"=nazwy$name,"wspX"=wsp$x,"wspY"=wsp$y) 
trojki <- dbGetQuery(con,"Select * from trojki")
   
shinyServer(function(input, output) {
   
   dataInput <- reactive({
      gestosc<-gestosc[-145,]
      if (input$dzien_tyg != "wszystkie") {
      gestosc<-gestosc[gestosc$weekday==input$dzien_tyg,]
      }
      gestosc<-gestosc[gestosc$hour >= input$zakres_godzin[1] & gestosc$hour <= input$zakres_godzin[2],]
      gestosc<-gestosc[,c(-1,-2)]
      gestosc<-colSums(gestosc)/sum(gestosc)
      gestosc<-data.frame("gestosc"=gestosc,"wspX"=wsp$x,"wspY"=wsp$y)
      gestosc
   })
   
   output$tabelka <- renderDataTable({
      data <- dataInput()
      data<-data.frame("Nazwa"=wspolrzedne$name,"Procent"=round(100*data$gestosc,2))
      data<-arrange(data,desc(Procent))
      
      data[1:5,]
   })
   
   output$map = renderPlot({
      data <- dataInput()
      par(mar = c(0,0,0,0))
      plot(x=1:2, y=1:2, type='n', asp = 1)
      usr <- par()$usr
      assign("usr", usr, envir = environment())
      rasterImage(plan,usr[1], usr[3], usr[2], usr[4])
      points(data$wspX, data$wspY, pch=16, cex=200*data$gestosc, col='blue')
      
   })
  
   
   SciezkiInput <- reactive({
         ktory<-nazwy[nazwy$name==input$eksponat2,1]
         trojki<-trojki[trojki$st1==ktory | trojki$st2==ktory |
                            trojki$st3==ktory ,]
         if (input$popularnosc==1) {
            trojki<-arrange(trojki,desc(ile))
         } else {
            trojki<-arrange(trojki,ile)
         }
         sciezki<-trojki
      
   })
   
   
   output$tabelka2 <- renderDataTable({
      
      data <- SciezkiInput()
      for (i in 1:3) {
         for (j in 1:4) {
         data[j,i]=nazwy[nazwy$code==data[j,i],2]
         }
      }
      colnames(data) <- c("Stanowisko","Stanowisko 2","Stanowisko 3","Ile razy")
      data[1:4,]
   })

   output$sciezki <- renderPlot({
      sciezki <- SciezkiInput()
      par(mar = c(0,0,0,0))
      plot(x=1:2, y=1:2, type='n', asp = 1)
      usr <- par()$usr
      assign("usr", usr, envir = environment())
      rasterImage(plan,usr[1], usr[3], usr[2], usr[4])
      points(wsp$x, wsp$y, pch=16, cex=2, col='blue')
      kol<-c("black",'mediumorchid4','olivedrab3','red3')
      for (i in 1:4) {
         ws1<-wspolrzedne[wspolrzedne$code==sciezki$st1[i],]
         ws2<-wspolrzedne[wspolrzedne$code==sciezki$st2[i],]
         ws3<-wspolrzedne[wspolrzedne$code==sciezki$st3[i],]
         arrows(ws1$wspX,ws1$wspY,ws2$wspX,ws2$wspY, lwd=2, code=2, col=kol[i])
         arrows(ws2$wspX,ws2$wspY,ws3$wspX,ws3$wspY, lwd=2, code=2, col=kol[i])
        
      }
   }) 
})