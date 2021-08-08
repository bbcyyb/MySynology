# !/bin/bash


###############################################
# Variables
###############################################
global_task_log_file=
# Don't change this password anytime
global_task_password="fK2!aN1#aC4!aC2)hL1^"

###############################################
# Functions
###############################################

function task_initialize_logfile() {
    task_log_folder=$1

    if [[ ! -d ${task_log_folder} ]]; then
        mkdir -p ${task_log_folder}
    fi

    task_currentdate="$(date +"%m_%d_%Y")"
    
    global_task_log_file="${task_log_folder}/${task_currentdate}.log"
}

function task_log() {
    task_message=$1

    task_timestamp="$(date +"%H:%M:%S")"

    if [[ -n "${global_task_log_file}" ]]; then
        echo -e "[${task_timestamp}] => ${task_message}">>${global_task_log_file}
    fi
}

function task_compress() {
    { 
        task_destination_dir=$1
        task_source_dir=$2
        task_package_name=${task_source_dir##*/}
        task_parent_source_dir=${task_source_dir%/*}
        tar -zcPf - -C "${task_parent_source_dir}" "${task_package_name}" | openssl des3 -salt -k ${global_task_password} | split -b 1000m -d -a 1 - "${task_destination_dir}/${task_package_name}.tar.gz."
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
        cat ${task_source_dir}/${task_file_prefix}.* | openssl des3 -d -k ${global_task_password} -salt | tar -zxf - -C "${task_destination_dir}"
    } || {
        return 1
    }

    return 0
}

function task_sync_to_baiduyun() {
    {
        task_destination_dir=$1
        task_source_dir=$2
        task_file_prefix=$3
         
        need_copy=-1
        if [[ -z ${task_file_prefix} ]]; then
            return 1
        fi

        for task_filtered_file in `ls "${task_source_dir}/${task_file_prefix}"*`
        do
            task_filtered_name="${task_filtered_file##*/}"
            if [[ ! -f "${task_destination_dir}/${task_filtered_name}" ]]; then
                need_copy=0
                break
            fi

            task_source_file_size=`ls -l "${task_source_dir}/${task_filtered_name}" | awk '{print $5}'`
            task_destination_file_size=`ls -l "${task_destination_dir}/${task_filtered_name}" | awk '{print $5}'`
            if [[ ${task_source_file_size} -ne ${task_destination_file_size}  ]]; then
                need_copy=0
                break
            fi
        done

        if [[ ${need_copy} -eq 0 ]]; then
            task_log "sync data"
            # delete existed files from dest
            rm -rf "${task_destination_dir}/${task_file_prefix}"*
            # move file to dest folder
            mv "${task_source_dir}/${task_file_prefix}"* "${task_destination_dir}/"
        else
            task_log "keep data"
            rm -rf "${task_source_dir}/${task_file_prefix}"*
        fi
    } || {
        return 1
    }

    return 0
}

###############################################
# Main Process
###############################################

# initialize
# task_compress "/volume1/backup/temp/photos" "/volume2/homes/Kevin Y/Drive/Moments/Kevin Y的相册/2011_05_装修_KevinYu"
# task_decompress "/volume1/backup" "/volume1/backup/temp/photos" "2011_05_装修_KevinYu.tar.gz"

# echo $?

