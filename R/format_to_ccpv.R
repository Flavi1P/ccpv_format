require(lubridate)
require(dplyr)
library(suncalc)

day_or_night <- function(longitude, latitude, datetime) {
  date = as.Date(datetime)
  # Calculate sunrise and sunset times
  sun_times <- getSunlightTimes(date, latitude, longitude)
  
  # Extract sunrise and sunset times
  sunrise <- sun_times$sunrise
  sunset <- sun_times$sunset
  
  # Check if it's day or night at the specified datetime
  if (datetime > sunrise & datetime < sunset) {
    return("day")
  } else {
    return("night")
  }
}

format_to_ccpv <- function(data, id_lot = NA, op_name = NA, entry_date = NA, pi_name = NA, pi_email = NA, pi_institut = NA, day_night = NA, sample_start = NA, sample_end = NA, sample_depth_int = NA, sample_sea_state = NA, flow_start = NA, flow_end = NA){
  
  data <- data|> 
    mutate(parsed_date = lubridate::ymd_hms(paste0(substr(date, 1, 8), substr(date, 10, 13), "00")),
           start_time = sprintf("%02d:%02d", hour(parsed_date), minute(parsed_date)),
           jar_qc = substr(sample_qc, 1, 1),
           plankton_qc = substr(sample_qc, 2, 2),
           conditionning_qc = substr(sample_qc, 3, 3),
           purity_qc = substr(sample_qc, 4, 4),
           #day_night = mapply(day_or_night, longitude, latitude, parsed_date))
           day_night = NA) |> 
    mutate_all(~ifelse(is.nan(.) | . == 99999, NA, .))
  
  entry_date_format = lubridate::ymd(entry_date)
  sample_date_format = lubridate::ymd(data$parsed_date)
  
  formatted_data <- data |> mutate("ID Lot" = id_lot,
                                   "Barcode" = NA,
                                   "Operator first and last name" = op_name,
                                   "Entry date (YYYY/MM/DD)" = format(entry_date_format, "%Y/%m/%d"),
                                   "Project Name" = scientificprog,
                                   "PI first and last name" = pi_name,
                                   "PI email address" = pi_email,
                                   "PI Institut name" = pi_institut,
                                   "Sample ID" = sampleid,
                                   "Ship" = ship,
                                   "Station ID" = stationid,
                                   "Sample date (YYYY/MM/DD)" = format(sample_date_format, "%Y/%m/%d"),
                                   "Day/night" = day_night,
                                   "Sample start time (HH:MM)" = start_time, #Replace "hour start"
                                   "Sample end time (HH:MM)" = sample_end, #Replace "hour end"
                                   "Sample start longitude" = longitude, #Replace longitude_start
                                   "Sample start latitude" = latitude, #Replace latitude_start
                                   "Sample end longitude" = longitude_end, #Replace "longitude_end"
                                   "Sample end latitude" = latitude_end, #Replace latitude_end
                                   "Sample depth intended (m)" = sample_depth_int, #Replace depth intended (m)
                                   "Sample cable length (m)" = cable_length,
                                   "Sample net type" = nettype,
                                   "Sample net mesh (µm)" = netmesh,
                                   "Sample sea state (0-12 Beaufort)" = sample_sea_state,
                                   "Sample flow meter start" = flow_start,
                                   "Sample flow meter end" = flow_end,
                                   "Sample depth record" = depth,
                                   "Sample CTD reference" = ctdref,
                                   "Sample other reference" = otherref,
                                   "Sample townb" = townb,
                                   "Sample tow type" = case_when(towtype == 0 ~ "Other sampling method",
                                                                 towtype == 1 ~ "oblique",
                                                                 towtype == 2 ~ "Horizontal",
                                                                 towtype == 3 ~ "Vertical",
                                                                 !towtype %in% c(1:3) ~ "NA"), #Attribute a plain language value to the numerical code. If not 1,2 or 3 return NA.
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
                                   "Sample depth QC" = case_when(depth_qc == 1 ~ "MEASURED by a depth sensor",#Attribute a plain language value to the numerical code. If not 1,2 or 3 return NA.
                                                                 depth_qc == 2 ~ "CALCULATED from cable length and angle",
                                                                 depth_qc == 3 ~ "ESTIMATED from cable length",
                                                                 !depth_qc %in% c(1:3) ~ "NA"),
                                   "Jar QC" = case_when(jar_qc == 1 ~ "JAR airtighness OK",
                                                        jar_qc == 2 ~ "JAR airtighness NOK"),
                                   "Richness QC" = case_when(plankton_qc == 1 ~ "NORMAL richness",
                                                             plankton_qc == 2 ~ "VERY RICH sample",
                                                             plankton_qc == 3 ~ "NO PLANKTON (almost) in sample"),
                                   "Conditionning QC" = case_when(conditionning_qc == 1 ~ "GOOD conditionning",
                                                                  conditionning_qc == 2 ~ "DRYED (no remaining liquid)",
                                                                  conditionning_qc == 3 ~ "ROTTEN (loss of fixative)"),
                                   "Purity QC" = case_when(purity_qc == 1 ~ "NO disturbing elements",
                                                           purity_qc == 2 ~ "ONE of FEW very large objects present in the jar",
                                                           purity_qc == 3 ~ "SOUP (phytoplankton-organic matter-clay/mud/mineral)"),
                                   "Sample barcode" = barcode,
                                   "Sample ship speed (knots)" = ship_speed_knots,
                                   "Sample jar number" = nb_jar) |> 
    select("ID Lot" : "Sample jar number")
  
  return(formatted_data)
}