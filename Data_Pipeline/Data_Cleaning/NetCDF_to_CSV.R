

library(tidyverse)
library(dplyr)
library(tidyr)
library(ncdf4)
library(lobstr)

## Pulls data from NetCDF Files from ARGO and puts them all into .csv files by
## year, with 2 files for each year (Key Variables and Covariates)

months <- c( "01" , "02" , "03" , "04" , "05" , "06" ,
             "07" , "08" , "09" , "10" , "11" , "12" )

days <- c( "01" , "02" , "03" , "04" , "05" , "06" , "07" , "08" , "09" , "10" ,
           "11" , "12" , "13" , "14" , "15" , "16" , "17" , "18" , "19" , "20" ,
           "21" , "22" , "23" , "24" , "25" , "26" , "27" , "28" , "29" , "30" , "31" )

key_vars <-c("PLATFORM_NUMBER","LONGITUDE","LATITUDE","JULD","REFERENCE_DATE_TIME")
covs <- c("TEMP_ADJUSTED","PRES_ADJUSTED","PSAL_ADJUSTED")

for( year in 2002:2021 ){
  for( j in 1:length(months) ){
    for( i in 1:length(days) ){
      
      file_name <- paste0( "../Data_Pipeline/data/data/" , year , 
                           months[j] , days[i] , "_prof.nc" )
      
      if( file.exists(file_name) && exists("working_df") ){
      
        df_to_bind <- get_dfs( file_name , key_vars = key_vars , covs = covs)
        
        key_vars_to_csv <- rbind( key_vars_to_csv , df_to_bind[[1]] )
        covariates_to_csv <- rbind( covariates_to_csv , df_to_bind[[2]] )
      }
      
      else if( file.exists(file_name) && !exists("working_df") ){
        
        working_df <- get_dfs( file_name , key_vars = key_vars , covs = covs )
        
        key_vars_to_csv <- working_df[[1]]
        covariates_to_csv <- working_df[[2]]
      }
      
      else print( paste(file_name , "doesn't exist" , sep = " ") )
    }
    out_file_key_vars <- paste0( year ,"_" , months[j] ,"_Key_Vars_Pacific.csv")
    out_file_covariates <- paste0( year , "_" , months[j] , "_Covariates_Pacific.csv")
    
    write.csv( key_vars_to_csv , out_file_key_vars , row.names = FALSE )
    write.csv( covariates_to_csv , out_file_covariates , row.names = FALSE )
    
    rm( list = c("working_df" , "covariates_to_csv" , "key_vars_to_csv"))
  }
}







