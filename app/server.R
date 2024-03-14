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
function(input, output, session) {
  
  data <- reactive({
    req(input$file)
    read_csv2(input$file$datapath)
  })
  
  read_csv_preview <- function(file_path) {
    if (file.exists(file_path)) {
      df <- read_csv2(file_path) |> 
        mutate(sample_comment = iconv(sample_comment, "latin1", "UTF-8",sub=''))# Read CSV file
      return(head(df))  # Display the first few rows as a preview
    } else {
      return(NULL)
    }
  }
  
  # Reactive function to read and display preview of the uploaded CSV file
  output$preview_table <- renderTable({
    req(input$file)  # Wait until a file is uploaded  
    file_path <- input$file$datapath
    read_csv_preview(file_path)
  })
  
  output$download_excel <- downloadHandler(
    filename = function() {
      paste(input$output_name, ".xlsx", sep = "")
    },
    content = function(file) {
      # Call your custom function with data, selected_date, and output_name
      result <- format_to_ccpv(data = data(), id_lot = input$id_lot, op_name = input$operator_name, entry_date = input$selected_date, pi_name = input$pi_name, pi_email = input$pi_email, pi_institut = input$pi_institut, day_night = NA, sample_start = input$sample_start_time, sample_end = input$sample_end_time, sample_depth_int = input$sample_dpeth_intended, sample_sea_state = input$sample_seastate, flow_start = input$flow_meter_start, flow_end = input$flow_meter_end)
      
      # Save result to Excel file
      openxlsx::write.xlsx(result, file)
    }
  )
}


