#!/bin/bash

. ./tasks.sh

###############################################
# Variables
###############################################


###############################################
# Functions
###############################################

function job_backup() {
    destination_dir=$1
    source_dir=$2

    task_check_dir ${source_dir}
    if [[ $1 -lt 0 ]]; then 
        return -1
    fi

    task_check_dir_and_create ${destination_dir}

    for sub_folder in `ls "${source_dir}"`
    do
        if [[ ${sub_folder} != "@eaDir" ]]; then
            task_compress "${destination_dir}" "${source_dir}/${sub_folder}"
            if [[ $1 -lt 0 ]]; then
                echo "${source_dir}/${sub_folder} failed to compress..."
                break
            fi

            # 验证，只有满足验证条件的压缩包能进入下一个环节
            task_verify_compressed_volumes

            # 移除不再需要的压缩卷
            task_remove_compressed_volumes

            #将指定文件的所有压缩卷拷贝到baiduyun同步文件夹中
            task_move_compressed_volumes
        fi
    done
}

function job_recover() {
    echo
}

###############################################
# Main Process
###############################################

# parse_arguments "$@"

# validate_and_run
