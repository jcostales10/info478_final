library(shiny)
library(ggplot2)
library(tidyverse)
library(plotly)
require(knitr)
opts_chunk$set(comment = NA, message = FALSE, tidy = FALSE)

# source("app_ui.R")
source("scripts/exemptions.R")


server <- function(input, output){
  
#--------------------- ENROLLMENT ---------------------#
  
  
#--------------------- EXEMPTIONS ---------------------#  
output$exemption_vis <- renderPlotly({
  
  # make df based on input
  exemption_modified <- exemption_summary  %>%
     filter(count == input$exemptions)
  
  
  # plotly piechart to display counts and percentages
  exemption_plot <- plot_ly(data = exemption_modified, labels = ~reasons,
                           values = ~count, type = 'pie')
  
  exemption_plot <- exemption_plot %>%
    layout(title = 'Exemption Count and Percentages',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
})  

#--------------------- IMMUNIZATION (COUNTY) ---------------------#
  
  
#--------------------- IMMUNIZATION (DISTRICT) ---------------------#
  
  
  
}