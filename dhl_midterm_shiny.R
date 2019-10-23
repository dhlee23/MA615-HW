library(shiny)
library(ggplot2)
library(ggmap)
library(maps)  
library(maptools)
library(mapproj)
load("/Users/daylelee/Desktop/MA 615 - R/MA615__Git_Repository/-Midterm Project/MA615_midterm/wdi_dat_pov.RData")
################################# Prework.
options <- c("Infant Mortality", "Life Expectancy", "Infant Mortality2")

g1 <- ggplot(subset(wdi_dat_pov, year == 2008), aes(x = GDP_perCap, y = infant_mortality)) + geom_point() +
    labs(x="GDP per Capita", y="Infant Mortality Rate", 
         title="Figure 0: Relationship between Infant Mortality Rate and GDP per Capita in year 2008") +
    theme_classic()

co <- c("United States", "Rwanda", "Mongolia", "Pakistan", "Lao PDR", "Bhutan", "Malaysia", "Brazil", "Ireland", "Japan", "China","Sweden", "Netherlands","Korea, Rep.")
lifexp_c <- subset(wdi_dat_pov, country %in% co) # subset specific countries from the data
lifexp_c0 <- subset(lifexp_c, year == 2016)

g2 <- ggplot(lifexp_c0) +
    aes(x = GDP_perCap, y = life_expectancy, colour = country) +
    geom_point(size = 2.56) +
    geom_text(aes(label = country), size=2, nudge_y = 0.8) +
    scale_color_hue() +
    labs(x = "GDP per Capita (USD)", y = "Life Expectancy (year)", title = "Figure 1: Life Expectancy and GDP per Capita by Country", subtitle = "(2016)", color = "Country") +
    scale_x_continuous(limits = c(0, 70000)) +
    theme_classic()

g3 <- ggplot(lifexp_c0) +
    aes(x = GDP_perCap, y = infant_mortality, colour = country) +
    geom_point(size = 2.56) +
    geom_text(aes(label = country), size=2, nudge_y = 1.9) +
    scale_color_hue() +
    labs(x = "GDP per Capita (USD)", y = "Infant Mortality Rate per 1,000 births", title = "Figure 2: Infant Mortality Rates by GDP per Capita", subtitle = "(2016)", color = "Country") +
    scale_x_continuous(limits = c(0, 70000)) +
    theme_classic()
########################################################################### UI ##
ui <- fluidPage(
    titlePanel("World Bank data"),
    selectInput("option", label = "Select the projection option", options),
    plotOutput(outputId = "plot", width = "100%")
)
############################################################################ SERVER ##
server <- function(input, output, session) {
    
    output$plot <- renderPlot({
        if (input$option == "Infant Mortality") {
            g1
        } else if (input$option == "Life Expectancy") {
            g2
        } else {
            g3
        }
    },height = 600, width = 900)
}
#################################
shinyApp(ui = ui, server = server)
