

path_to_data_dir = "~/repos/typhoon_data/bwp_2019"

path_to_file = "~/repos/typhoon_data/bwp_2019/bwp012019.dat"

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
