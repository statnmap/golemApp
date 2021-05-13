#' mod1 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_mod1_ui <- function(id){
  ns <- NS(id)
  tagList(

    leaflet::leafletOutput(ns("map")),
    reactable::reactableOutput(ns("table"))
  )
}
    
#' mod1 Server Function
#'
#' @noRd 
mod_mod1_server <- function(input, output, session){
  ns <- session$ns
 

  districts <- sf::st_read(dsn = "https://raw.githubusercontent.com/ppatrzyk/polska-geojson/master/wojewodztwa/wojewodztwa-medium.geojson")
  github_csv <- read.table("https://raw.githubusercontent.com/Camil88/geoMapX/main/data/dataApp.csv", header = TRUE, stringsAsFactors = FALSE, sep = ";")
  #


 df_dateFormat <- github_csv %>%
     dplyr::mutate(github_csv, statusDateConverted = as.Date(statusDate, format = "%d.%m.%Y")) %>%
     transform(orderNr = as.character(orderNr))

   # github_csv2 <- dplyr::mutate(github_csv, statusDateConverted = as.Date(statusDate, format = "%d.%m.%Y"))
   # ddd <- transform(github_csv2, orderNr = as.character(orderNr))
   # df_dateFormat <- ddd

   dateFrom <- anytime::anydate("2020-11-18")
   dateTo <- anytime::anydate("2020-11-18")

   func_FilterDate <- function(df, from, to){
     df[df$statusDateConverted >= from & df$statusDateConverted <= to,]
   }

   data_app <- func_FilterDate(df_dateFormat, dateFrom, dateTo)
   colnames(data_app)[1] <- "transitNr"
  
  
  output$map <- leaflet::renderLeaflet({

    leaflet::leaflet() #%>%
      # leaflet::addProviderTiles(providers$Stamen.TonerLite,
      #                  options = leaflet::providerTileOptions(noWrap = TRUE)
      # ) %>%
      # leaflet::addPolygons(
    #     #data = districts,
    #     #group = "districts",
    #     #layerId = ~id,
    #     #fillColor = "green",
    #     weight = 2,
    #     opacity = 0.3,
    #     color = "#6b747d",
    #     fillOpacity = 0.2,
    #     highlight = leaflet::highlightOptions(
    #       weight = 2,
    #       color = "#9b22bf",
    #       opacity = 0.8,
    #       fillOpacity = 0.5,
    #       bringToFront = TRUE)
    #   )     
  })

  output$table <- reactable::renderReactable({
    reactable::reactable(
      data = data_app
    )
  })
 
  
}
    
## To be copied in the UI
# mod_mod1_ui("mod1_ui_1")
    
## To be copied in the server
# callModule(mod_mod1_server, "mod1_ui_1")
 
