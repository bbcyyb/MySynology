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
    { 
        destination_dir=$1
        source_dir=$2
        package_name=${source_dir##*/}
        parent_source_dir=${source_dir%/*}
        tar -zcPf - -C "${parent_source_dir}" "${package_name}" | openssl des3 -salt -k ${password} | split -b 4000m -d -a 1 - "${destination_dir}/${package_name}.tar.gz."
    } || {
        return -1
    }

    return 0
}

function task_decompress() {
    {
        destination_dir=$1
        source_dir=$2
        file_prefix=$3
        cat ${source_dir}/${file_prefix}.* | openssl des3 -d -k ${password} -salt | tar -zxf - -C "${destination_dir}"
    } || {
        return -1
    }

    return 0
}

function task_verify_compressed_volumes() {
    echo
}

function task_remove_compressed_volumes() {
    echo
}

function task_move_compressed_volumes() {
    echo
}

###############################################
# Main Process
###############################################

# initialize
# task_compress "/volume1/backup/temp/photos" "/volume2/homes/Kevin Y/Drive/Moments/Kevin Y的相册/2011_05_装修_KevinYu"
# task_decompress "/volume1/backup" "/volume1/backup/temp/photos" "2011_05_装修_KevinYu.tar.gz"

# echo $?

echo "....."
