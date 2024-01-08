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

colnames_clean <- readxl::read_excel('temp/temp1.xlsx', skip = 1) |> colnames()

colnames_to_format <- colnames(data)

same <- colnames_to_format[which(colnames_to_format %in% colnames_clean)]
diff <- colnames_to_format[which(!colnames_to_format %in% colnames_clean)]
diff2 <- colnames_to_format[which(!colnames_clean %in% colnames_to_format)]

data <- data |> 
  mutate(parsed_date = lubridate::ymd_hms(paste0(substr(date, 1, 8), substr(date, 10, 13), "00")))

formatted_data <- data |> mutate("Operator first and last name" = NA,
                                 "Entry date (YYYY/MM/DD)" = NA,
                                 "Project Name" = scientificprog,
                                 "PI first and last name" = NA,
                                 "PI email address" = NA,
                                 "PI Institut name" = NA,
                                 "Sample ID" = sampleid,
                                 "Ship" = ship,
                                 "Station ID" = stationid,
                                 "Sample date (YYYY/MM/DD)" = format(parsed_date, "%Y/%m/%d"),
                                 "Day/night" = NA,
                                 "Sample start time (HH:MM)" = NA, #Replace "hour start"
                                 "Sample end time (HH:MM)" = NA, #Replace "hour end"
                                 "Sample start longitude" = longitude, #Replace longitude_start
                                 "Sample start latitude" = latitude, #Replace latitude_start
                                 "Sample end longitude" = longitude_end, #Replace "longitude_end"
                                 "Sample end latitude" = latitude_end, #Replace latitude_end
                                 "Sample depth intended (m)" = NA, #Replace depth intended (m)
                                 "Sample cable length (m)" = cable_length,
                                 "Sample net type" = nettype,
                                 "Sample net mesh (µm)" = netmesh,
                                 "Sample sea state (0-12 Beaufort)" = NA,
                                 "Sample flow meter start" = NA,
                                 "Sample flow meter end" = NA,
                                 "Sample depth record" = depth,
                                 "Sample CTD reference" = ctdref,
                                 "Sample other reference" = otherref,
                                 "Sample townb" = townb,
                                 "Sample tow type" = case_when(towtype == 1 ~ "oblique", #Attribute a plain language value to the numerical code. If not 1,2 or 3 return NA.
                                                               towtype == 2 ~ "vertical",
                                                               towtype == 3 ~ "horizontal",
                                                               !towtype %in% c(1:3) ~ "NA"),
                                 "Sample cable angle (degree)" = cable_angle,
                                 "Sample cable speed (m/s)" = cable_speed,
                                 "Sample net surface" = netsurf,
                                 "Sample depth max (m)" = zmax, #Replace zmax
                                 "Sample depth min (m)" = zmin, #Replace zmin
                                 "Sample net duration (mn)" = net_duration,
                                 "Sample volume sampled (m³)" = vol,
                                 "Sample comment" = sample_comment,
                                 "Sample volume QC" = case_when(vol_qc == 1 ~ "RECORDED volume (flowmeter)",#Attribute a plain language value to the numerical code. If not 1,2 or 3 return NA.
                                                                vol_qc == 2 ~ "CALCULATED volume (using the mean volume of other nets)",
                                                                vol_qc == 3 ~ "ESTIMATED volume (net AREA x towed DISTANCE)",
                                                                !vol_qc %in% c(1:3) ~ "NA"),
                                 "Sample dpeth QC" = case_when(depth_qc == 1 ~ "MEASURED by a depth sensor",#Attribute a plain language value to the numerical code. If not 1,2 or 3 return NA.
                                                                depth_qc == 2 ~ "CALCULATED from cable length and angle",
                                                                depth_qc == 3 ~ "ESTIMATED from cable length",
                                                                !depth_qc %in% c(1:3) ~ "NA"),
                                 "Sample QC" = sample_qc,
                                 "Sample barcode" = barcode,
                                 "Sample ship speed (knots)" = ship_speed_knots,
                                 "Sample jar number" = nb_jar)
                        
                                 
