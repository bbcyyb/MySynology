#!/bin/bash


###############################################
# Functions
###############################################

source_dir="/var/services/homes/Kevin Y/Drive/Moments/Kevin Y的相册"
destination_dir="/var/services/homes/dev/backup/temp/photos"

time="$(date +"%Y-%m-%d")"

###############################################
# Functions
###############################################

function initialize() {
    if [ ! -d "${source_dir}" ]; then
        echo "==> source folder is not existed, exit"
        exit 1
    fi

    if [ ! -d "${destination_dir}" ]; then
        echo "==> Create destination folder ${destination_dir}"
        mkdir -p ${destination_dir}
    fi
} 

function compress_core() {
    # var1 is sub_folder name
    var1=$1
    tar -zcPf - -C "${source_dir}" "${var1}" | openssl des3 -salt -k Damaoxian7954 | split -b 4000m -d -a 1 - "${destination_dir}/${var1}.tar.gz"
}

function compress() {
    for sub_folder in `ls "${source_dir}"`
    do
        if [[ -d "${source_dir}/${sub_folder}" && ${sub_folder} != "@eaDir" ]]; then
            if [ ${sub_folder} == "2008_12_大学照片_KevinYu" ]; then
                echo "compress"
                compress_core "${sub_folder}"
            fi
        fi
    done
}

###############################################
# Main Process
###############################################

initialize
compress


echo "....."
