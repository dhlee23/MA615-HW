## Mapping Assignment Problem 1 ##
## MA615
## Dae Hyun Lee
##################################
library(shiny)
library(ggplot2)
library(ggmap)
library(maps)
library(maptools)
library(mapproj)
#################
options <- c("standard", "cylindrical", "mercator", "sinusoidal", "gnomonic", "rectangular", "cylequalarea")

mapWorld <- map_data("world")
mp1 <- ggplot(mapWorld, aes(x=long, y=lat, group=group))+
    geom_polygon(fill="white", color="black") +
    coord_map(xlim=c(-180,180), ylim=c(-60, 90))
###########################################################################건드릴거없음.
ui <- fluidPage(
    titlePanel("World Map"),
    sidebarLayout(
        sidebarPanel(
            selectInput("option", label = "Select the projection option", options)
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)
################### A reactive expression to return the dataset corresponding to the user choice
server <- function(input, output, session) {
    
    output$plot <- renderPlot({
        if (input$option == "standard") {
            mp1
        } else if (input$option == "rectangular") {
            mp2 <- mp1 + coord_map(input$option, parameters = 0, xlim=c(-180,180), ylim=c(-60, 90))
            mp2
        } else if (input$option == "cylequalarea") {
            mp2 <- mp1 + coord_map(input$option, parameters = 0, xlim=c(-180,180), ylim=c(-60, 90))
            mp2
        } else {
            mp2 <- mp1 + coord_map(input$option, xlim=c(-180, 180), ylim=c(-60,90))
            mp2
        }
    })
}
#################################
shinyApp(ui = ui, server = server)
