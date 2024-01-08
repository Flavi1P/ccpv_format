#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  titlePanel("CSV to Excel Converter"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File", accept = ".csv"),
      textInput("output_name", "Enter Output File Name (without extension)"),
      textInput("operator_name", "Name and surname"),
      dateInput("selected_date", "Select Date", value = Sys.Date()), 
      textInput("pi_name", "PI Name and surname"),
      textInput("pi_email", "PI email address"),
      textInput("pi_institut", "PI Institut"),
      textInput("sample_start_time", "Sample start time"),
      textInput("sample_end_time", "Sample end time"),
      textInput("sample_dpeth_intended", "Sample intended depth"),
      textInput("sample_seastate", "Sample sea state"),
      textInput("flow_meter_start", "Flow meter start"),
      textInput("flow_meter_end", "Flow meter end"),
      actionButton("generate_btn", "Generate Excel")
    ),
    
    mainPanel(
      downloadButton("download_excel", "Download Excel File")
    )
  )
)
