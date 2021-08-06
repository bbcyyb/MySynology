# !/bin/bash


###############################################
# Variables
###############################################

time="$(date +"%Y-%m-%d")"
# Don't change this password anytime
task_password="fK2!aN1#aC4!aC2)hL1^"

###############################################
# Functions
###############################################

function task_compress() {
    { 
        task_destination_dir=$1
        task_source_dir=$2
        task_package_name=${task_source_dir##*/}
        task_parent_source_dir=${task_source_dir%/*}
        tar -zcPf - -C "${task_parent_source_dir}" "${task_package_name}" | openssl des3 -salt -k ${task_password} | split -b 4000m -d -a 1 - "${task_destination_dir}/${task_package_name}.tar.gz."
    } || {
        return 1
    }

    return 0
}

function task_decompress() {
    {
        task_destination_dir=$1
        task_source_dir=$2
        task_file_prefix=$3
        cat ${task_source_dir}/${task_file_prefix}.* | openssl des3 -d -k ${task_password} -salt | tar -zxf - -C "${task_destination_dir}"
    } || {
        return 1
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

