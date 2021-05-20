##
## Useful buoys -- Deep enough to use the variable representative isotherm 
## formula (> 400 meters) and should also have surface temperature values.
## 
## For the variable isotherm formula, the equation is as follows:
## 
##  TT = T(MLD) – 0.25[T(MLD) – T(400m)]
##
## TT -- Thermocline Temperature
## T(MLD) -- Temperature at the base of the mixed layer
## T(400m) -- Temperature at 400 meters
## 
## For T(MLD), we use surface temperature minus 0.8. Surface temperature is
## calculated as the mean of the temperature from 10 to 30 meters deep.
##
## See Fiedler 2010, pg. 319, for more details. Link below:
## https://aslopubs.onlinelibrary.wiley.com/doi/pdfdirect/10.4319/lom.2010.8.313
## 
## We also calculate surface salinity as a column 
##
## the month argument is if we want to use multiple months of data and keep 
## month as a variable in the final data frame
getThermDepth <- function(all_buoys_no_date,month = FALSE){
  
  deepBuoys <- all_buoys_no_date %>% 
    filter(PRES_ADJUSTED > 400 & TEMP_ADJUSTED < 35) %>%
    group_by(PLATFORM_NUMBER , LONGITUDE , LATITUDE) %>%
    summarise( TEMP_DEEP = max(TEMP_ADJUSTED ) )
  
  if (month){
    surfaceBuoys <- all_buoys_no_date %>%
      filter(PRES_ADJUSTED < 30 & PRES_ADJUSTED > 10) %>%
      group_by(PLATFORM_NUMBER , LONGITUDE , LATITUDE, month) %>%
      summarise( SURFACE_TEMP = mean(TEMP_ADJUSTED),
                 SURFACE_SAL = mean(PSAL_ADJUSTED) )
    deepBuoys <- all_buoys_no_date %>% 
      filter(PRES_ADJUSTED > 400 & TEMP_ADJUSTED < 35) %>%
      group_by(PLATFORM_NUMBER , LONGITUDE , LATITUDE, month) %>%
      summarise( TEMP_DEEP = max(TEMP_ADJUSTED ) )
  }else{
    deepBuoys <- all_buoys_no_date %>% 
      filter(PRES_ADJUSTED > 400 & TEMP_ADJUSTED < 35) %>%
      group_by(PLATFORM_NUMBER , LONGITUDE , LATITUDE) %>%
      summarise( TEMP_DEEP = max(TEMP_ADJUSTED ) )
    
    surfaceBuoys <- all_buoys_no_date %>%
      filter(PRES_ADJUSTED < 30 & PRES_ADJUSTED > 10) %>%
      group_by(PLATFORM_NUMBER , LONGITUDE , LATITUDE) %>%
      summarise( SURFACE_TEMP = mean(TEMP_ADJUSTED),
                 SURFACE_SAL = mean(PSAL_ADJUSTED) )
  }
  
  
  usefulBuoys <- inner_join( deepBuoys , surfaceBuoys )
  
  usefulBuoys$TEMP_MLD <- usefulBuoys$SURFACE_TEMP - 0.8
  
  usefulBuoys$TEMP_THERMOCLINE <- usefulBuoys$TEMP_MLD - 0.25 * 
    ( usefulBuoys$TEMP_MLD - usefulBuoys$TEMP_DEEP )
  
  usefulBuoys$THERMOCLINE_DEPTH <- NA
  
  
  
  ## This for() loop adds the THERMOCLINE_DEPTH to each entry using the value
  ## immediately below the thermocline level.
  ##
  ## ~ 1-2% of the data is quite strange here: These data points tend to be at
  ## high latitudes with low surface temperatures.
  ##
  ## Also, this code is slow, even though it runs.
  for(i in 1:nrow(usefulBuoys)){
    single_working_buoy <- all_buoys_no_date %>%
      filter( PLATFORM_NUMBER == 
                usefulBuoys$PLATFORM_NUMBER[i] &
                LONGITUDE == usefulBuoys$LONGITUDE[i] &
                LATITUDE == usefulBuoys$LATITUDE[i] )
    
    dist_to_thermocline <- abs( single_working_buoy$TEMP_ADJUSTED - 
                                  usefulBuoys$TEMP_THERMOCLINE[i] )
    temp_sorting_value <- sort( dist_to_thermocline )[7]
    
    rows_near_therm <- single_working_buoy[ dist_to_thermocline <
                                              temp_sorting_value , ]
    
    usefulBuoys$THERMOCLINE_DEPTH[i] <- min( rows_near_therm$PRES_ADJUSTED )
    
  }
  
  return(usefulBuoys)
}
