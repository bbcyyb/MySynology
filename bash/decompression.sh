
#!/bin/bash

source_dir="/var/services/homes/dev/backup/temp/photos"
file_prefix="2008_12_大学照片_KevinYu.tar"
destination_dir="${source_dir}" # don't include decompresed folder.



time="$(date +"%Y-%m-%d")"

###############################################
# Functions
###############################################

initialize() {
    if [ ! -d "${source_dir}" ]; then
        echo "==> source folder is not existed, exit"
        exit 1
    fi

    if [ ! -d "${destination_dir}" ]; then
        echo "==> Create destination folder ${c_destination_dir}"
        mkdir -p ${c_destination_dir}
    fi
} 

decompressCore() {
    cat ${source_dir}/${file_prefix}.* | openssl des3 -d -k Damaoxian7954 -salt | tar -xf - -C "${destination_dir}"
}


decompress() {
    decompressCore
}

###############################################
# Main Process
###############################################

initialize
decompress


echo "....."
