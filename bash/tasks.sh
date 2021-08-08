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

function task_get_currenttime() {
    return "$(date +"H%:%M:%S")"
}

function task_get_currentdate() {
    return "$(date +"%Y_%m_%d")"
}

function task_initialize_logfile() {
    task_log_folder=$1

    if [[ ! -d ${task_log_folder} ]]; then
        mkdir -p ${task_log_folder}
    fi

    task_get_currentdate
    task_currentdate=$?
    
    global_task_log_file="${task_log_folder}/${task_currentdate}.log"
}

function task_log() {
    task_message=$1

    task_get_currenttime
    task_timestamp=$?

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
        tar -zcPf - -C "${task_parent_source_dir}" "${task_package_name}" | openssl des3 -salt -k ${global_task_password} | split -b 4000m -d -a 1 - "${task_destination_dir}/${task_package_name}.tar.gz."
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

function task_verify_compressed_volumes() {
    {
        task_destination_dir=$1
        task_source_dir=$2
        # task_file_prefix=$3
        task_file_prefix_list=()
         
        for task_file in `ls "${task_source_dir}"`
        do
            task_file_prefix_list=("${task_file_prefix_list[@]}" "${task_file%.*}")
        done

        for task_file_prefix in ${task_file_prefix_list[@]}
        do
            need_copy=0
            for task_filtered_file in `ls "${task_source_dir}/${task_filtered_file}"*`
            do
                if [[ ! -f "${task_destination_dir}/${task_filtered_file}" ]]; then
                    need_copy=1
                    break
                fi

                task_source_file_size=`ls -l "${task_source_dir}/${task_filtered_file}" | awk '{print $5}'`
                task_destination_file_size=`ls -l "${task_destination_dir}/${task_filtered_file}" | awk '{print $5}'`
                if [[ ${task_source_file_size} -ne ${task_destination_file_size}  ]]; then
                    need_copy=1
                    break
                fi
                
            done

            if [[ ${need_copy} -eq 1 ]]; then
                # delete existed files from dest
                rm -rf "${task_destination_dir}/${task_filtered_file}"*
                # move file to dest folder
                mv "${task_source_dir}/${task_filtered_file}"* "${task_destination_dir}/"
            else
                rm -rf "${task_source_dir}/${task_filtered_file}"*
            fi
        done
    } || {
        return 1
    }

    return 0
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

