require(lubridate)
require(dplyr)

format_to_ccpv <- function(data, op_name = NA, entry_date = NA, pi_name = NA, pi_email = NA, pi_institut = NA, day_night = NA, sample_start = NA, sample_end = NA, sample_depth_int = NA, sample_sea_state = NA, flow_start = NA, flow_end = NA){
  
  data <- data |> 
    mutate(parsed_date = lubridate::ymd_hms(paste0(substr(date, 1, 8), substr(date, 10, 13), "00")))
  
  formatted_data <- data |> mutate("Operator first and last name" = op_name,
                                   "Entry date (YYYY/MM/DD)" = entry_date,
                                   "Project Name" = scientificprog,
                                   "PI first and last name" = pi_name,
                                   "PI email address" = pi_email,
                                   "PI Institut name" = pi_institut,
                                   "Sample ID" = sampleid,
                                   "Ship" = ship,
                                   "Station ID" = stationid,
                                   "Sample date (YYYY/MM/DD)" = format(parsed_date, "%Y/%m/%d"),
                                   "Day/night" = day_night,
                                   "Sample start time (HH:MM)" = sample_start, #Replace "hour start"
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
  
  
  return(formatted_data)
}