
import sys
import os
from task import initialize_logfile, compress, sync_to_baiduyun, decompress


def initialize(log_folder):
    if log_folder:
        initialize_logfile(log_folder)


def backup(destination_dir, source_dir, baiduyun_dir):
    print(f"start to backup photos from {source_dir} to {baiduyun_dir}")

    for sub_folder in os.listdir(source_dir):
        if sub_folder != "@eaDir":
            print(f"compress {sub_folder}......")
            compress(destination_dir, os.path.join(source_dir, sub_folder))
            if not os.path.exists(os.path.join(destination_dir, f"{sub_folder}.tar.gz")):
                print(f"{os.path.join(source_dir, sub_folder)} failed to compress......")
                break

            if baiduyun_dir:
                sync_to_baiduyun(baiduyun_dir, destination_dir, f"{sub_folder}.tar.gz")

    print("complete...")


def recover(job_destination_dir, job_source_dir, job_file_prefix):
    print(f"decompress {job_file_prefix}")
    decompress(job_destination_dir, job_source_dir, job_file_prefix)
