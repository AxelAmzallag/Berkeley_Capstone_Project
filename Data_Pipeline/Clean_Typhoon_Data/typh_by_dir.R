# how to use this script
# from the commandline run the following
# Rscript typh_by_dir.R  directory_name
# and inside that directory should be a nicely formatted typhoon csv

if (dir.exists("~/R")) {.libPaths("~/R")}  # needed for tim's library ocd
library(tidyverse)
library(stringr)
library(magrittr)
library(dplyr)


# path_to_data_dir = "~/repos/typhoon_data/bwp_2019"

# path_to_file = "~/repos/typhoon_data/bwp_2019/bwp012019.dat"

typh_by_file <- function(path_to_file) {
    x <- read.table(path_to_file, stringsAsFactors=FALSE)
    x<- x[, c(2, 3, 7, 8, 9, 10, 11)]
    colnames(x) <- c("yr_cyc_num", "date_time", "lat", "long", "vmax", "mslp", "typh_grade")
    return(x)
}


typh_by_yr <- function(path_to_data_dir) {
    x <- data.frame(yr_cyc_num=character(0), date_time=character(0),
                    lat=character(0), long=character(0), vmax=character(0),
                    mslp=character(0), typh_grade=character(0))
    files_lst <- list.files(path_to_data_dir, pattern="(\\.dat|\\.txt)$")
    for (val in files_lst) {
        path_to_file <- file.path(path_to_data_dir, val)
        y <- typh_by_file(path_to_file)
        x <- rbind(x, y)
    }
    return(x)
}


main <- function() {
    args <- commandArgs(trailingOnly = TRUE)  # elims need for --args
    path_to_data_dir = args[1]
    df <- typh_by_yr(path_to_data_dir)
    # print(path_to_data_dir)
    # head(df)
    # drop commas, and cast mslp and vmax as numeric
    df <- as.data.frame(lapply(df, function(column) gsub(pattern = ",",
                                                         replacement = "",
                                                         column)))
    
    df %<>% mutate(mslp = as.numeric(as.character(mslp)),
                   vmax = as.numeric(as.character(vmax)),
                   lat = as.character(lat),
                   long = as.character(long))
    

    # test case to see if everything works
    ## df[str_detect(df$lat, "N"),] <- df %>% filter(str_detect(lat, "N")) %>%
    ##                                        mutate(lat = str_glue("-", "{lat}"))

    # concatenate each South latitdue with a negative sign
    df[str_detect(df$lat, "S"),] <- df %>% filter(str_detect(lat, "S")) %>%
                                       mutate(lat = str_glue("-", "{lat}"))

    # concatenate each West longitude with a negative sign
    df[str_detect(df$long, "W"),] <- df %>% filter(str_detect(long, "W")) %>%
                                       mutate(long = str_glue("-", "{long}"))

    # remove N,S,E,W from lats and longs, cast as numeric, and rescale to normal degrees
    # rather than the default tenths of degrees used by the navy
    df %<>% mutate(lat = as.numeric(str_replace(lat, pattern = "(N|S)", replacement = "")) / 10,
                   long = as.numeric(str_replace(long, pattern = "(E|W)", replacement = "")) / 10)
    
    
    print(head(df))
    # print(path_to_data_dir)
    # remove front slash is lazy
    dir_name= str_replace(path_to_data_dir, pattern = "\\/", replacement = "")
    # print(dir_name)
    file_name = str_glue(dir_name, "_typh_data.csv")
    # print(dir_name)
    # print(file.path(dir_name, file_name))
    # save newly minted csv to directory passed on commandline
    # will be saved as follows ./dir_name/dir_name_typh_data.csv
    write.csv(df, file.path(dir_name, file_name))
    
    
}

main()
