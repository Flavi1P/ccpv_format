library(tidyverse)
library(googledrive)
library(readxl)

project <- "/remote/complex/piqv/plankton_rw/zooscan_archives_monitoring"
test_case <- "Zooscan_ptb_jb_2018_sn001"

file <- paste(project, test_case, "Zooscan_meta/zooscan_sample_header_table.csv", sep = "/")

data <- read_csv2(file)
colnames(data)

drive_auth()
ccpv_id <- drive_find(pattern = "CCPv Inventaire", type = "folder", shared_drive = "Migration CCPv")$id
ccpv_files <- drive_ls(as_id(ccpv_id))

template_id <- ccpv_files |> filter(name == "Template") |> pull(id)
template_files <- drive_ls(as_id(template_id))

my_file_id <- template_files |> filter(name == "Inventory_Monitoring_survey_Sampling.xlsx") |> pull(id)

my_file <- read_xlsx(sprintf("https://docs.google.com/uc?id=%s&export=download", my_file_id))

dl <- drive_download(
  as_id(my_file_id),
  path = 'temp/temp1.xlsx', 
  overwrite = TRUE, 
  type = "xlsx")

test <- readxl::read_excel('temp/temp1.xlsx', skip = 1)
