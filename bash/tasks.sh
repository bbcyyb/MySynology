# !/bin/bash


###############################################
# Variables
###############################################

time="$(date +"%Y-%m-%d")"
# Don't change this password anytime
password="fK2!aN1#aC4!aC2)hL1^"

###############################################
# Functions
###############################################

function task_check_dir_and_create() {
    if [[ ! -z "${1}" && ! -d "${1}" ]]; then
        echo "==> folder ${1} is not exist, create it!"
        mkdir -p ${1}
        return -1
    fi

    return 0
}

function task_check_dir() {
    if [[ ! -z "${1}" && ! -d "${1}" ]]; then
        echo "==> folder ${1} is not exist!"
        return -1
    fi

    return 0
}


function task_compress() {
    # var1=$1
    # tar -zcPf - -C "${source_dir}" "${var1}" | openssl des3 -salt -k Damaoxian7954 | split -b 4000m -d -a 1 - "${destination_dir}/${var1}.tar.gz"
    
    destination_dir=$1
    source_dir=$2
    package_name=${source_dir##*/}
    parent_source_dir=${source_dir%/*}
    tar -zcPf - -C "${parent_source_dir}" "${package_name}" | openssl des3 -salt -k ${password} | split -b 4000m -d -a 1 - "${destination_dir}/${package_name}.tar.gz."
    return 0
}

function task_decompress() {
    destination_dir=$1
    source_dir=$2
    file_prefix=$3
    cat ${source_dir}/${file_prefix}.* | openssl des3 -d -k ${password} -salt | tar -zxf - -C "${destination_dir}"
}

function initialize_() {
    if [ ! -d "${source_dir}" ]; then
        echo "==> source folder is not existed, exit"
        exit 1
    fi

    if [ ! -d "${destination_dir}" ]; then
        echo "==> Create destination folder ${destination_dir}"
        mkdir -p ${destination_dir}
    fi
} 

function compress_() {
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

# initialize
# task_compress "/volume1/backup/temp/photos" "/volume2/homes/Kevin Y/Drive/Moments/Kevin Y的相册/2011_05_装修_KevinYu"
# task_decompress "/volume1/backup" "/volume1/backup/temp/photos" "2011_05_装修_KevinYu.tar.gz"

# echo $?

echo "....."
