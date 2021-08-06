#!/bin/bash

. ./tasks.sh

###############################################
# Variables
###############################################


###############################################
# Functions
###############################################

function job_backup() {
    job_destination_dir=$1
    job_source_dir=$2

    if [[ ! -d "${job_source_dir}" ]]; then 
        echo "==> source folder ${job_source_dir} is not exist, exit..."
        return -1
    fi

    if [[ ! -d "${job_destination_dir}" ]]; then 
        echo "==> backup folder  ${job_destination_dir} is not exist, create it!"
        mkdir -p ${job_destination_dir}
    fi

    for job_sub_folder in `ls "${job_source_dir}"`
    do
        if [[ ${job_sub_folder} != "@eaDir" ]]; then
            echo "compress ${job_sub_folder}......"
            task_compress "${job_destination_dir}" "${job_source_dir}/${job_sub_folder}"
            if [[ $? -ne 0 ]]; then
                echo "${job_source_dir}/${job_sub_folder} failed to compress..."
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
    job_destination_dir=$1
    job_source_dir=$2
    job_file_prefix=$3

    if [[ ! -d "${job_source_dir}" ]]; then
        echo "==> source folder ${job_source_dir} is not exist, exit..."
        exit -1
    fi

    ls ${job_source_dir}/${job_file_prefix}*
    if [[ $? -ne 0 ]]; then
        echo "==> file begin with ${job_file_prefix} is not existed, exit..."
        exit -1
    fi

    if [[ ! -d "${job_destination_dir}" ]]; then
        echo "==> destination folder  ${job_destination_dir} is not exist, create it!"
        mkdir -p ${job_destination_dir}
    fi

    echo "decomress ${job_file_prefix}"
    task_decompress "${job_destination_dir}" "${job_source_dir}" "${job_file_prefix}"
}

###############################################
# Main Process
###############################################

# parse_arguments "$@"

# validate_and_run
