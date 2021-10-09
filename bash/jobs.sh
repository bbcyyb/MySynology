#!/bin/bash

. ./tasks.sh

###############################################
# Functions
###############################################

function job_initialize() {
    job_log_folder=$1 

    if [[ -n ${job_log_folder} ]]; then
        task_initialize_logfile "${job_log_folder}"
    fi
}

function job_backup() {
    job_destination_dir=$1
    job_source_dir=$2
    job_baiduyun_dir=$3

    if [[ -z "${job_destination_dir}" ]]; then
        echo "--destination parameter is missing."
        return -1
    fi

    if [[ -z "${job_source_dir}" ]]; then
        echo "--source parameter is missing."
        return -1
    fi

    if [[ ! -d "${job_source_dir}" ]]; then 
        echo "==> source folder ${job_source_dir} is not existed."
        return -1
    fi

    if [[ ! -d "${job_destination_dir}" ]]; then 
        echo "==> backup folder ${job_destination_dir} is not existed, create it!"
        mkdir -p "${job_destination_dir}"
    fi

    if [[ -n "${job_baiduyun_dir}" && ! -d "${job_baiduyun_dir}" ]]; then
        echo "==> baiduyun folder ${job_baiduyun_dir} is not existed."
        return -1
    fi

    task_log "start to backup photos from ${job_source_dir} to ${job_baiduyun_dir}"

    for job_sub_folder in `ls "${job_source_dir}"`
    do
        if [[ ${job_sub_folder} != "@eaDir" ]]; then
            echo "compress ${job_sub_folder}......"
            task_log "compress ${job_sub_folder} folder"
            task_compress "${job_destination_dir}" "${job_source_dir}/${job_sub_folder}"
            if [[ $? -ne 0 ]]; then
                echo "${job_source_dir}/${job_sub_folder} failed to compress......"
                break
            fi
            
            if [[ -n ${job_baiduyun_dir} ]]; then
                task_log "sync ${job_sub_folder}.tar.gz to baiduyun"
                task_sync_to_baiduyun "${job_baiduyun_dir}" "${job_destination_dir}" "${job_sub_folder}.tar.gz"
            fi
        fi
    done

    task_log "complete..."
}

function job_recover() {
    job_destination_dir=$1
    job_source_dir=$2
    job_file_prefix=$3

    if [[ -z ${job_destination_dir} ]]; then
        echo "--destination is missing."
        return -1
    fi

    if [[ -z ${job_source_dir} ]]; then
        echo "--source is missing."
        return -1
    fi

    if [[ -z ${job_file_prefix} ]]; then
        echo "--file prefix is missing."
        return -1
    fi

    if [[ ! -d "${job_source_dir}" ]]; then
        echo "==> source folder ${job_source_dir} is not existed."
        return -1
    fi

    ls "${job_source_dir}/${job_file_prefix}"*
    if [[ $? -ne 0 ]]; then
        echo "==> file begin with ${job_file_prefix} is not existed."
        return -1
    fi

    if [[ ! -d "${job_destination_dir}" ]]; then
        echo "==> destination folder  ${job_destination_dir} is not exist, create it!"
        mkdir -p "${job_destination_dir}"
    fi

    echo "decomress ${job_file_prefix}"
    task_decompress "${job_destination_dir}" "${job_source_dir}" "${job_file_prefix}"
}

function job_aliddns() {
    job_accesskey_id=$1
    job_accesskey_sec=$2


    if [[ -z ${job_accesskey_id} ]]; then
        echo "--accesskey_id is missing."
        return -1
    fi

    if [[ -z ${job_accesskey_sec} ]]; then
        echo "--accesskey_sec is missing."
        return -1
    fi

    task_refresh_record "${job_accesskey_id}" "${job_accesskey_sec}"
}

###############################################
# Main Process
###############################################

# parse_arguments "$@"

# validate_and_run
