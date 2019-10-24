## Mapping Assignment Problem 2 ##
## MA615
## Dae Hyun Lee
##################################
#load libraries
library(shiny)
library(tidyverse)
library(leaflet.extras)
library(leaflet)   # This creates a prettier, interactive map.
library(maps)     # Draw geographical maps.
library(htmlwidgets)  # To save the map as a web page.
library(magrittr)

# import data
col_uni <- read_csv("Colleges_and_Universities.csv")
# data cleaning
# Blaine The Beauty Career School-Boston & Rets Technical Center do not have geo-coordinates in the dataset.
col_uni <- col_uni[c(1:57,60),]
# put geo-coordinates for the Harvard University of Public Health 
col_uni$Latitude[58] <- 42.3355
col_uni$Longitude[58] <- -71.1022
bounds <- map('state', c('Massachusetts'), fill=TRUE, plot=FALSE)
col_uni$size <- ifelse(col_uni$NumStudent < 1000, "S", 
                          ifelse(col_uni$NumStudent < 10000 | col_uni$NumStudent >= 1000,"M",
                                 ifelse(col_uni$NumStudent >= 10000, "deep", "L")))

########################################## ui
ui <- fluidPage(
    titlePanel("Colleges and Universities within the City of Boston"),
    
    mainPanel( 
        leafletOutput(outputId = "mymap")
        ## absolutePanel(top = 60, left = 20, checkboxInput("markers", "Depth", FALSE), checkboxInput("heat", "Heatmap", FALSE) 
        )
)
###################################################### server
server <- function(input, output, session) {
    icons <- awesomeIcons(
        icon = 'education',
        iconColor = 'black',
        library = 'glyphicon', # Options are 'glyphicon', 'fa', 'ion'.
        markerColor = 'lightred',   # 겉에 여백 색깔
        squareMarker = TRUE
    )
    
    output$mymap <- renderLeaflet({
        leaflet(data = col_uni) %>% 
            setView(-71.1218,42.3535, zoom = 10) %>%
            addProviderTiles("CartoDB.Positron", group = "Map") %>%         
            addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%      
            addProviderTiles("Esri.WorldStreetMap", group = "Street") %>%
            addProviderTiles("Stamen.Watercolor", group = "Watercolor") %>%
            addAwesomeMarkers(~Longitude, ~Latitude, label = ~Name, group = "Col_Uni", icon=icons) %>%
            addScaleBar(position = "bottomleft") %>%   
            addPolygons(data=bounds, group="States", weight=2, fillOpacity = 0) %>%
            addLayersControl(
                baseGroups = c("Map", "Satellite", "Street", "Watercolor"),
                overlayGroups = c("Col_Uni", "States"),
                options = layersControlOptions(collapsed = FALSE)
            )
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
