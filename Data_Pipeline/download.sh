#!/usr/bin/env bash


## short script to download NetCDF binary files from ARGOs ftp servers
## feed a start year , end year, start month end month
## to select all files within {start year,..,end year} X {start month,..,end month}
## depends on wget
##
##   >  chmod 755 download.sh
##   >  ./download.sh

if [ $# -eq 0 ];then
    echo call with help flag [-h] for usage information
    echo "./download.sh [-h] start_year end_year start_month end_month"
    exit 1
fi


if [[ "$1" == "-h" ]]; then
    echo Usage information
    echo -e Run \"./download.sh start_year end_year start_month end_year\" to extract all NetCDF files
    echo from all months from start_month to end_month during the timespan of start_year end_year
    echo
    echo
    echo -e Run \"./download.sh -y year start_month end_year\" to extract all NetCDF files
    echo from all months from start_month to end_month in the given year
    exit 0

fi

if [[ "$1" == "-y" ]]; then
    year=$2
    strt_mnth=$3
    end_mnth=$4
    url=$(echo ftp://ftp.ifremer.fr/ifremer/argo/geo/pacific_ocean/${year}/{$strt_mnth..$end_mnth}/*)
    eval wget ${url}  -q -P ./data
    exit 0
fi


strt_year=$1
strt_mnth=$3
end_year=$2
end_mnth=$4



url=$(echo ftp://ftp.ifremer.fr/ifremer/argo/geo/pacific_ocean/{$strt_year..$end_year}/{$strt_mnth..$end_mnth}/*)
eval wget ${url}  -q -P ./data
