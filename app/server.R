#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(readr)
library(dplyr)
library(lubridate)
source("/remote/complex/home/fpetit/ccpv_format/R/format_to_ccpv.R")

# Define server logic required to draw a histogram
function(input, output) {
  data <- reactive({
    req(input$file)
    read_csv2(input$file$datapath)
  })
  
  output$download_excel <- downloadHandler(
    filename = function() {
      paste(input$output_name, ".xlsx", sep = "")
    },
    content = function(file) {
      # Call your custom function with data, selected_date, and output_name
      result <- format_to_ccpv(data = data(), op_name = input$operator_name, entry_date = input$selected_date, pi_name = input$pi_name, pi_email = input$pi_email, pi_institut = input$pi_institut, day_night = NA, sample_start = input$sample_start_time, sample_end = input$sample_end_time, sample_depth_int = input$sample_dpeth_intended, sample_sea_state = input$sample_seastate, flow_start = input$flow_meter_start, flow_end = input$flow_meter_end)
      
      # Save result to Excel file
      openxlsx::write.xlsx(result, file)
    }
  )
}
