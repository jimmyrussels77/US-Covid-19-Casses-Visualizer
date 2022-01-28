# Title     : TODO
# Objective : TODO
# Created by: Jarred
# Created on: 12/4/2020

library(mongolite)
library(ggplot2)
library(dplyr)
library(maps)
library(ggmap)
library(lubridate)
library(gridExtra)
library(shiny)
library(shinyWidgets)
library(jsonlite)
library(shinythemes)

#url_path = "mongodb+srv://projectUser:user@cluster0.nxnvw.mongodb.net/Test?retryWrites=true&w=majority"

#collection1 <- mongo(collection = "DeathCountsbySexAgeState", db = "ProjectData", url = url_path, verbose = TRUE)
#collection3 <- mongo(collection = "DeathCountsbyWeekEndingDateState", db = "ProjectData", url = url_path, verbose = TRUE)
#collection4 <- mongo(collection = "DeathCountsforInfluenzaPneumoniaCOVID-19", db = "ProjectData", url = url_path, verbose = TRUE)
#collection5 <- mongo(collection = "DeathCountsintheUnitedStatesbyCounty", db = "ProjectData", url = url_path, verbose = TRUE)
#collection6 <- mongo(collection = "DeathsFocusonAges0-18Years", db = "ProjectData", url = url_path, verbose = TRUE)
#collection2 <- mongo(collection = "DeathCountsbySexAgeWeek", db = "ProjectData", url = url_path, verbose = TRUE)

#print(mongo)



#collection1$count()
#collection1$iterate()$one()

loadData <- function(qry){
  mongo <- mongo(collection = "DeathCountsbySexAgeState", db = "ProjectData", url = "mongodb+srv://projectUser:user@cluster0.nxnvw.mongodb.net/Test?retryWrites=true&w=majority", verbose = TRUE)

  df <- mongo$find(qry)
  return(df)
}


loadData2 <- function(qry2){
  mongo2 <- mongo(collection = "DeathCountsbySexAgeWeek", db = "ProjectData", url = "mongodb+srv://projectUser:user@cluster0.nxnvw.mongodb.net/Test?retryWrites=true&w=majority", verbose = TRUE)

  df2 <- mongo2$find(qry2)
  return(df2)
}


loadData3 <- function(qry3){
  mongo3 <- mongo(collection = "DeathCountsbyWeekEndingDateState", db = "ProjectData", url = "mongodb+srv://projectUser:user@cluster0.nxnvw.mongodb.net/Test?retryWrites=true&w=majority", verbose = TRUE)

  df3 <- mongo3$find(qry3)
  return(df3)
}


loadData4 <- function(qry4){
  mongo4 <- mongo(collection = "DeathCountsintheUnitedStatesbyCounty", db = "ProjectData", url = "mongodb+srv://projectUser:user@cluster0.nxnvw.mongodb.net/Test?retryWrites=true&w=majority", verbose = TRUE)

  df4 <- mongo4$find(qry4)
  return(df4)
}


loadData5 <- function(qry5){
  mongo5 <- mongo(collection = "DeathCountsforInfluenzaPneumoniaCOVID-19", db = "ProjectData", url = "mongodb+srv://projectUser:user@cluster0.nxnvw.mongodb.net/Test?retryWrites=true&w=majority", verbose = TRUE)

  df5 <- mongo5$find(qry5)
  return(df5)
}






ui <- fluidPage(
  navbarPage("Covid-Database", theme = shinytheme("lumen")),
  tabsetPanel(type = "pills",
              tabPanel("Death Counts:Sex,Age,State", fluid = TRUE, icon = NULL,
                       sidebarLayout(
                         sidebarPanel(

                           titlePanel("Data Options"),
                           pickerInput("stateInput", "State", choices=c("United States", "Alabama", "Alaska", "Arizona","Arkansas", "California", "Colorado", "Connecticut","Delaware",
                                                                        "Florida","Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa","Kansas", "Kentucky", "Louisiana",
                                                                        "Maine", "Maryland", "Massachusetts", "Michigan","Minnesota", "Mississippi", "Missouri", "Montana",
                                                                        "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York","North Carolina",
                                                                        "North Dakota", "Ohio", "Oklahoma", "Oregon","Pennsylvania", "Rhode Island", "South Carolina",
                                                                        "South Dakota", "Tennessee", "Texas", "Utah", "Vermont","Virginia", "Washington", "West Virginia",
                                                                        "Wisconsin", "Wyoming"), options = list('actions-box' = TRUE), multiple = F),

                           pickerInput("sexInput", "Sex", choices = c("All Sexes", "Male", "Female"), options = list ('actions-box'= TRUE), multiple = F),

                           pickerInput ("ageInput", "Age Group", choices = c("Under 1", "0-17 years", "1-4 years", "5-14 years", "15-24 years", "18-29 years", "25-34 years", "30-49 years",
                                                                             "35-44 years", "45-54 years", "50-64 years", "55-64 years", "65-74 years", "75-84 years", "85 years and over", "All Ages"), options = list('actions-box' = TRUE), multiple = F),
                           downloadButton('downloadData', 'Download'),
                           downloadButton('downloadAll', 'Download All'),

                         ),
                         mainPanel(
                           verbatimTextOutput(outputId = "Text"),
                           dataTableOutput(outputId = "qryResults")
                         )


                       )
              ),
              tabPanel("Death Counts:Sex,Age,Week", fluid = TRUE, icon = NULL,
                       sidebarLayout(
                         sidebarPanel(

                           titlePanel("Data Options"),


                           pickerInput("sexInput2", "Sex", choices = c("All Sexes", "Male", "Female"), options = list ('actions-box'= TRUE), multiple = F),

                           pickerInput ("ageInput2", "Age Group", choices = c("Under 1", "0-17 years", "1-4 years", "5-14 years", "15-24 years", "18-29 years", "25-34 years", "30-49 years",
                                                                              "35-44 years", "45-54 years", "50-64 years", "55-64 years", "65-74 years", "75-84 years", "85 years and over", "All Ages"), options = list('actions-box' = TRUE), multiple = F),

                           pickerInput("endWeekInput2", "End Week", choices = c("02/01/2020", "02/08/2020", "02/15/2020", "02/22/2020", "02/29/2020", "03/07/2020", "03/14/2020", "03/21/2020", "03/28/2020",
                                                                                "04/04/2020", "04/11/2020", "04/18/2020", "04/25/2020", "05/02/2020", "05/09/2020", "05/16/2020", "05/23/2020", "05/30/2020",
                                                                                "06/06/2020", "06/13/2020", "06/20/2020", "06/27/2020", "07/04/2020", "07/11/2020", "07/18/2020", "07/25/2020", "08/01/2020",
                                                                                "08/08/2020", "08/15/2020", "08/22/2020", "08/29/2020", "09/05/2020", "09/12/2020", "09/19/2020", "09/26/2020", "10/03/2020",
                                                                                "10/10/2020", "10/17/2020", "10/24/2020", "10/31/2020", "11/07/2020", "11/14/2020", "11/21/2020", "11/28/2020"), options = list('actions-box' = TRUE), multiple = F),
                          downloadButton('downloadData2', 'Download'),
                          downloadButton('downloadAll2', 'Download All'),
                         ),
                         mainPanel(
                           verbatimTextOutput(outputId = "Text2"),
                           dataTableOutput(outputId = "qryResults2")
                         )


                       )
              ),
              tabPanel("Death Counts: WeekEndingData, State", fluid = TRUE, icon = NULL,
                       sidebarLayout(
                         sidebarPanel(

                           titlePanel("Data Options"),

                           pickerInput("stateInput3", "State", choices=c("United States", "Alabama", "Alaska", "Arizona","Arkansas", "California", "Colorado", "Connecticut","Delaware",
                                                                         "Florida","Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa","Kansas", "Kentucky", "Louisiana",
                                                                         "Maine", "Maryland", "Massachusetts", "Michigan","Minnesota", "Mississippi", "Missouri", "Montana",
                                                                         "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York","North Carolina",
                                                                         "North Dakota", "Ohio", "Oklahoma", "Oregon","Pennsylvania", "Rhode Island", "South Carolina",
                                                                         "South Dakota", "Tennessee", "Texas", "Utah", "Vermont","Virginia", "Washington", "West Virginia",
                                                                         "Wisconsin", "Wyoming"), options = list('actions-box' = TRUE), multiple = F),

                           pickerInput("endWeekInput3", "End Week", choices = c("02/01/2020", "02/08/2020", "02/15/2020", "02/22/2020", "02/29/2020", "03/07/2020", "03/14/2020", "03/21/2020", "03/28/2020",
                                                                                "04/04/2020", "04/11/2020", "04/18/2020", "04/25/2020", "05/02/2020", "05/09/2020", "05/16/2020", "05/23/2020", "05/30/2020",
                                                                                "06/06/2020", "06/13/2020", "06/20/2020", "06/27/2020", "07/04/2020", "07/11/2020", "07/18/2020", "07/25/2020", "08/01/2020",
                                                                                "08/08/2020", "08/15/2020", "08/22/2020", "08/29/2020", "09/05/2020", "09/12/2020", "09/19/2020", "09/26/2020", "10/03/2020",
                                                                                "10/10/2020", "10/17/2020", "10/24/2020", "10/31/2020", "11/07/2020", "11/14/2020", "11/21/2020", "11/28/2020"), options = list('actions-box' = TRUE), multiple = F),
                           downloadButton('downloadData3', 'Download'),
                           downloadButton('downloadAll3', 'Download All')
                         ),
                         mainPanel(
                           verbatimTextOutput(outputId = "Text3"),
                           dataTableOutput(outputId = "qryResults3")
                         )


                       )
              ),
              tabPanel("Death Counts:State, County", fluid = TRUE, icon = NULL,
                       sidebarLayout(
                         sidebarPanel(

                           titlePanel("Data Options"),


                           pickerInput("stateInput4", "State", choices=c("AL", "AK", "AZ", "AR", "CA", "CO", "CT","DE","DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI",
                                                                         "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA",
                                                                         "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"), options = list('actions-box' = TRUE), multiple = F),

                           downloadButton('downloadData4', 'Download'),
                           downloadButton('downloadAll4', 'Download All')
                         ),
                         mainPanel(
                           verbatimTextOutput(outputId = "Text4"),
                           dataTableOutput(outputId = "qryResults4")
                         )


                       )
              ),
              tabPanel("Death Counts:Influenza,Pneumonia,Covid-19", fluid = TRUE, icon = NULL,
                       sidebarLayout(
                         sidebarPanel(

                           titlePanel("Data Options"),

                           pickerInput("stateInput5", "Jurisdiction", choices=c("United States", "Alabama", "Alaska", "Arizona","Arkansas", "California", "Colorado", "Connecticut","Delaware",
                                                                                "Florida","Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa","Kansas", "Kentucky", "Louisiana",
                                                                                "Maine", "Maryland", "Massachusetts", "Michigan","Minnesota", "Mississippi", "Missouri", "Montana",
                                                                                "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York","North Carolina",
                                                                                "North Dakota", "Ohio", "Oklahoma", "Oregon","Pennsylvania", "Rhode Island", "South Carolina",
                                                                                "South Dakota", "Tennessee", "Texas", "Utah", "Vermont","Virginia", "Washington", "West Virginia",
                                                                                "Wisconsin", "Wyoming"), options = list('actions-box' = TRUE), multiple = F),


                           pickerInput ("ageInput5", "Age Group", choices = c("0-17 years", "65+ years" , "All Ages", "18-64 years"), options = list('actions-box' = TRUE), multiple = F),


                           downloadButton('downloadData5', 'Download'),
                           downloadButton('downloadAll5', 'Download All')
                         ),
                         mainPanel(
                           verbatimTextOutput(outputId = "Text5"),
                           dataTableOutput(outputId = "qryResults5")
                         )


                       )
              )

  )





)










server <- function(input, output, session){

  observe({print(input$stateInput)})
  observe({print(input$sexInput)})

  qryResults <- reactive({

    state <- list(state = input$stateInput)
    age <- list(age = input$ageInput)
    sex <- list(sex = input$sexInput)

    qry <- paste0('{"State" : "', state, '", "Sex" : "', sex,'", "Age Group" : "', age,'"}')


    df <- loadData(qry)
    return(df)
  })



  qryResults2 <- reactive({


    age <- list(age = input$ageInput2)
    sex <- list(sex = input$sexInput2)
    endWeek <- list(endWeek = input$endWeekInput2)

    qry2 <- paste0('{"End Week" : "', endWeek, '", "Sex" : "', sex,'", "Age Group" : "', age,'"}')

    df2 <- loadData2(qry2)
    return(df2)
  })



  qryResults3 <- reactive({

    state <- list(state = input$stateInput3)
    endWeek <- list(endWeek = input$endWeekInput3)

    qry3 <- paste0('{"End Week" : "', endWeek, '", "State" : "', state,'"}')

    df3 <- loadData3(qry3)
    return(df3)
  })




  qryResults4 <- reactive({

    state <- list(state = input$stateInput4)


    qry4 <- paste0('{"State" : "', state, '"}')

    df4 <- loadData4(qry4)
    return(df4)
  })




  qryResults5 <- reactive({

    state <- list(state = input$stateInput5)
    age <- list(age = input$ageInput5)


    qry5 <- paste0('{"Jurisdiction" : "', state, '", "Age Group" : "', age,'"}')

    df5 <- loadData5(qry5)
    return(df5)
  })




  output$qryResults <- renderDataTable({
    qryResults()

  })



  output$qryResults2 <- renderDataTable({
    qryResults2()
  })



  output$qryResults3 <- renderDataTable({
    qryResults3()
  })



  output$qryResults4 <- renderDataTable({
    qryResults4()
  })



  output$qryResults5 <- renderDataTable({
    qryResults5()
  })



  output$downloadData <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },

    content = function(file){
      write_json(qryResults(), file, row.names = FALSE)
    }
  )


  output$downloadData2 <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },

    content = function(file){
      write_json(qryResults2(), file, row.names = FALSE)
    }
  )


  output$downloadData3 <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },

    content = function(file){
      write_json(qryResults3(), file, row.names = FALSE)
    }
  )

  output$downloadData4 <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },

    content = function(file){
      write_json(qryResults4(), file, row.names = FALSE)
    }
  )

  output$downloadData5 <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },

    content = function(file){
      write_json(qryResults5(), file, row.names = FALSE)
    }
  )

  allResults <- reactive({
    all <- paste0('{}')
    a <- loadData(all)
    return(a)
  })

  allResults2 <- reactive({
    all <- paste0('{}')
    a <- loadData2(all)
    return(a)
  })

  allResults3 <- reactive({
    all <- paste0('{}')
    a <- loadData3(all)
    return(a)
  })

  allResults4 <- reactive({
    all <- paste0('{}')
    a <- loadData4(all)
    return(a)
  })

  allResults5 <- reactive({
    all <- paste0('{}')
    a <- loadData5(all)
    return(a)
  })




  output$downloadAll <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },
    content = function(file){
      write_json(allResults(), file, row.names = FALSE)
    }
  )

  output$downloadAll2 <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },
    content = function(file){
      write_json(allResults2(), file, row.names = FALSE)
    }
  )

  output$downloadAll3 <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },
    content = function(file){
      write_json(allResults3(), file, row.names = FALSE)
    }
  )

  output$downloadAll4 <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },
    content = function(file){
      write_json(allResults4(), file, row.names = FALSE)
    }
  )

  output$downloadAll5 <- downloadHandler(
    filename = function(){
      paste(input$dataset, ".json", sep = "")
    },
    content = function(file){
      write_json(allResults5(), file, row.names = FALSE)
    }
  )


  output$text1 <- renderText(nrow(qryResults()))
  output$text2 <- renderText(nrow(qryResults2()))
  output$text3 <- renderText(nrow(qryResults3()))
  output$text4 <- renderText(nrow(qryResults4()))
  output$text5 <- renderText(nrow(qryResults5()))

}


shinyApp(ui= ui, server = server)






