#!/bin/sh

echo "start"

# Get ipv6 address on my synology
local_ip=`ifconfig eth0 | grep "Scope:Global" | awk '{print $3}'`
local_ip=${local_ip%%/*}

cur_dateTime=`date`
echo "new ipv6 is ${local_ip}, updated at ${cur_dateTime}"

# If target file exists
file="/volume1/backup/sync/ipv6.txt"
if [ -f "${file}" ]; then
    rm -r ${file}
fi

touch ${file}

echo "new ipv6 address, updated at ${cur_dateTime}" >> ${file}
echo "${local_ip}" >> ${file}
echo "" >> ${file}
echo "" >> ${file}
echo "MySynology:" >> ${file}
echo "http://[${local_ip}]:5000" >> ${file}
echo "" >> ${file}
echo "" >> ${file}
echo "qBittorrent:" >> ${file}
echo "http://[${local_ip}]:8999" >> ${file}

echo "done"





