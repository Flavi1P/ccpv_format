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
  titlePanel("CSV to Excel Converter for sampling table"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File", accept = ".csv"),
      textInput("output_name", "Enter Output File Name (without extension)"),
      textInput("operator_name", "Name and surname"),
      dateInput("selected_date", "Select Date", value = Sys.Date()), 
      textInput("id_lot", "ID Lot"),
      textInput("pi_name", "PI Name and surname"),
      textInput("pi_email", "PI email address"),
      textInput("pi_institut", "PI Inst itut"),
      downloadButton("download_excel", "Download Excel File")
    ),
    
    mainPanel(
      tableOutput("preview_table")
    )
  )
)
