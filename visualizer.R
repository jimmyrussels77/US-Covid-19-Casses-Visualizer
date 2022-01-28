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
library(leaflet)
library(geojsonio)
library(dplyr)
library(leaflet.extras)

# Testers used initially to test the data sets
# 5 different data sets are used with each having their own parameteres and
# user filter options

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

# With each database we have (5) we load each one of them by connecting
# to mongoDB with each of the data set
# In oorder to connnect to mongodb, we use mongolite library in order to connect to the collections
# the datasets will be passed and useed later in the code
# df = datafields

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

loadDataMap <- function(qryMap){
  mongoMap <- mongo(collection = "DeathCountsforMap", db = "ProjectData", url = "mongodb+srv://projectUser:user@cluster0.nxnvw.mongodb.net/Test?retryWrites=true&w=majority", verbose = TRUE)

  dfMap <- mongoMap$find(qryMap)
  return(dfMap)
}




# User interface using R shiny in order to visually display to our users.
# 5 different tab panels are set so the user can switch between data sets with ease
# multiple picker inputs for the different column choices (State, Age, Sex, End Week, Start Week)
# Html is also included into the UI which is added by our html files
# 2 download buttons are present. 1 that downloads the currently selected data on the screen, and the other that downloads the whole currently selected data set.

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

                           pickerInput ("ageInput", "Age group", choices = c("Under 1", "0-17 years", "1-4 years", "5-14 years", "15-24 years", "18-29 years", "25-34 years", "30-49 years",
                                                                             "35-44 years", "45-54 years", "50-64 years", "55-64 years", "65-74 years", "75-84 years", "85 years and over", "All Ages"), options = list('actions-box' = TRUE), multiple = F),
                           downloadButton('downloadData', 'Download'),
                           downloadButton('downloadAll', 'Download All'),

                         ),
                         mainPanel(
                           includeHTML("CovidSite.html"),
                           leafletOutput("map"),
                           #p(),
                           #actionButton("recalc", "New Points"),
                           verbatimTextOutput(outputId = "Text"),
                           dataTableOutput(outputId = "qryResults"),
                           includeHTML("CovidSiteB.html")
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
                           includeHTML("CovidSite.html"),
                           verbatimTextOutput(outputId = "Text2"),
                           dataTableOutput(outputId = "qryResults2"),
                           includeHTML("CovidSiteB.html")
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
                           includeHTML("CovidSite.html"),
                           verbatimTextOutput(outputId = "Text3"),
                           dataTableOutput(outputId = "qryResults3"),
                           includeHTML("CovidSiteB.html")
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
                           includeHTML("CovidSite.html"),
                           verbatimTextOutput(outputId = "Text4"),
                           dataTableOutput(outputId = "qryResults4"),
                           includeHTML("CovidSiteB.html")
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
                           includeHTML("CovidSite.html"),
                           textOutput("mapDisclaimer"),
                           p(),
                           textOutput("USTotal"),
                           p(),
                           verbatimTextOutput(outputId = "Text5"),
                           dataTableOutput(outputId = "qryResults5"),
                           includeHTML("CovidSiteB.html")
                         )


                       )
              )

  )





)








# Server side code:
# Observe function is used to observe user input in the console for testing and debugging
# qryResults takes the picker input from the user interface and applies the queries onto the dataset
# each qryResults has diffeererent parameters depending on which data set is being used
# paste0 is being used to filter the data set
# it will then return the data fields and display each data field by rendering the table
# and displaying it for the user.
#
#

server <- function(input, output, session){

  observe({print(input$stateInput)})
  observe({print(input$sexInput)})

  qryResults <- reactive({

    state <- list(state = input$stateInput)
    age <- list(age = input$ageInput)
    sex <- list(sex = input$sexInput)

    qry <- paste0('{"State" : "', state, '", "Sex" : "', sex,'", "Age group" : "', age,'"}')


    df <- loadData(qry)
    return(df)
  })

  # #query map data
  # qryResultsMap <- reactive({
  #
  #   state <- list(state = input$stateInput)
  #
  #   qryMap <- paste0('{"State" : "', state, '"}')
  #
  #
  #   dfMap <- loadData(qryMap)
  #   return(dfMap)
  # })

  #generate map

   output$map <- renderLeaflet({
     leaflet() %>% addProviderTiles(providers$Stamen.Toner) %>%
      setView(lng = -99, lat = 40, zoom = 3) %>%
       addMarkers(lat=32.77, lng=-86.82, label = "Alabama: Total deaths - 4453") %>%
       addMarkers(lat=64.06, lng=-152.27, label = "Alaska: Total Deaths - 94") %>%
       addMarkers(lat=34.27, lng=-111.66, label = "Arizona: Total Deaths - 5773") %>%
       addMarkers(lat=34.89, lng=-92.44, label = "Arkansas: Total Deaths - 2457") %>%
       addMarkers(lat=37.18, lng=-119.46, label = "California: Total Deaths - 18505") %>%
       addMarkers(lat=38.99, lng=-105.54, label = "Colorado: Total Deaths - 2708") %>%
       addMarkers(lat=41.62, lng=-72.72, label = "Connecticut: Total Deaths - 4604") %>%
       addMarkers(lat=38.98, lng=-75.5, label = "Deleware: Total Deaths - 658") %>%
       addMarkers(lat=28.63, lng=-82.44, label = "Florida: Total Deaths - 17669") %>%
       addMarkers(lat=32.64, lng=-83.44, label = "Georgia: Total Deaths - 7737") %>%
       addMarkers(lat=20.29, lng=-156.37, label = "Hawaii: Total Deaths - 304") %>%
       addMarkers(lat=44.35, lng=-114.61, label = "Idaho: Total Deaths - 908") %>%
       addMarkers(lat=40.04, lng=-89.19, label = "Illinois: Total Deaths - 10956") %>%
       addMarkers(lat=39.89, lng=-86.28, label = "Indiana: Total Deaths - 5355") %>%
       addMarkers(lat=42.07, lng=-93.49, label = "Iowa: Total Deaths - 2644") %>%
       addMarkers(lat=38.49, lng=-98.38, label = "Kansas: Total Deaths - 1675") %>%
       addMarkers(lat=37.53, lng=-85.3, label = "Kentucky: Total Deaths - 2148") %>%
       addMarkers(lat=31.06, lng=-91.99, label = "Louisiana: Total Deaths - 5574") %>%
       addMarkers(lat=45.36, lng=-69.24, label = "Maine: Total Deaths - 219") %>%
       addMarkers(lat=39.05, lng=-76.79, label = "Maryland: Total Deaths - 4848") %>%
       addMarkers(lat=42.25, lng=-71.8, label = "Massachusetts: Total Deaths - 8551") %>%
       addMarkers(lat=44.34, lng=-85.41, label = "Michigan: Total Deaths - 7750") %>%
       addMarkers(lat=46.28, lng=-94.3, label = "Minnesota: Total Deaths - 3354") %>%
       addMarkers(lat=32.73, lng=-89.66, label = "Mississippi: Total Deaths - 3623") %>%
       addMarkers(lat=38.35, lng=-92.45, label = "Missouri: Total Deaths - 4297") %>%
       addMarkers(lat=47.05, lng=-109.63, label = "Montana: Total Deaths - 624") %>%
       addMarkers(lat=41.53, lng=-99.79, label = "Nebraska: Total Deaths - 1158") %>%
       addMarkers(lat=39.32, lng=-116.63, label = "Nevada: Total Deaths - 1964") %>%
       addMarkers(lat=43.68, lng=-71.58, label = "New Hampshire: Total Deaths - 510") %>%
       addMarkers(lat=40.19, lng=-74.67, label = "New Jersey: Total Deaths - 15054") %>%
       addMarkers(lat=34.4, lng=-106.11, label = "New Mexico: Total Deaths - 1222") %>%
       addMarkers(lat=42.95, lng=-75.52, label = "New York: Total Deaths - 12534") %>%
       addMarkers(lat=35.55, lng=-79.38, label = "North Carolina: Total Deaths - 3117") %>%
       addMarkers(lat=47.45, lng=-100.46, label = "North Dakota: Total Deaths - 725") %>%
       addMarkers(lat=40.28, lng=-82.79, label = "Ohio: Total Deaths - 6382") %>%
       addMarkers(lat=35.58, lng=-97.49, label = "Oklahoma: Total Deaths - 2170") %>%
       addMarkers(lat=43.93, lng=-120.55, label = "Oregon: Total Deaths - 770") %>%
       addMarkers(lat=40.87, lng=-77.79, label = "Pennsylvania: Total Deaths - 10461") %>%
       addMarkers(lat=41.67, lng=-71.55, label = "Rhode Island: Total Deaths - 1243") %>%
       addMarkers(lat=33.91, lng=-80.89, label = "South Carolina: Total Deaths - 4211") %>%
       addMarkers(lat=44.44, lng=-100.22, label = "South Dakota: Total Deaths - 796") %>%
       addMarkers(lat=35.85, lng=-86.35, label = "Tennessee: Total Deaths - 4304") %>%
       addMarkers(lat=31.47, lng=-99.33, label = "Texas: Total Deaths - 21895") %>%
       addMarkers(lat=39.3, lng=-111.67, label = "Utah: Total Deaths - 891") %>%
       addMarkers(lat=44.06, lng=-72.66, label = "Vermont: Total Deaths - 71") %>%
       addMarkers(lat=37.52, lng=-78.85, label = "Virginia: Total Deaths - 4129") %>%
       addMarkers(lat=47.38, lng=-120.44, label = "Washington: Total Deaths - 2365") %>%
       addMarkers(lat=38.64, lng=-80.62, label = "West Virginia: Total Deaths - 426") %>%
       addMarkers(lat=44.62, lng=-89.99, label = "Wisconsin: Total Deaths - 3537") %>%
       addMarkers(lat=42.99, lng=-107.55, label = "Wyoming: Total Deaths - 184") %>%
       addMarkers(lat=38.91, lng=-77.01, label = "District of Columbia: Total Deaths - 827")
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


  # For the download all button, we first create a data field that
  # copies the load data without doing any queries or filtering
  # then download all is called using our allResults from earlier
  # in order to download the whole data set with .json extention
  #
  #

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


  # For the download all button, we first create a data field that
  # copies the load data without doing any queries or filtering
  # then download all is called using our allResults from earlier
  # in order to download the whole data set with .json extention
  #
  #

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
  session$onSessionEnded(function() {
    stopApp()
  })
  output$mapDisclaimer <- renderText({
    "Map data as of 12/2/2020"
  })

  output$USTotal <- renderText({
    "Total US deaths as of 12/2/2020 - 249570"
  })
  # Output text for testing and debugging in the console

  output$text1 <- renderText(nrow(qryResults()))
  output$text2 <- renderText(nrow(qryResults2()))
  output$text3 <- renderText(nrow(qryResults3()))
  output$text4 <- renderText(nrow(qryResults4()))
  output$text5 <- renderText(nrow(qryResults5()))

}


shinyApp(ui= ui, server = server)
