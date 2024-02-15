
import sys
import os
from task import initialize_logfile, compress, sync_to_baiduyun, decompress


def initialize(log_folder):
    if log_folder:
        initialize_logfile(log_folder)


def backup(destination_dir, source_dir, baiduyun_dir):
    for sub_folder in os.listdir(source_dir):
        if sub_folder != "@eaDir":
            compress(destination_dir, os.path.join(source_dir, sub_folder))

            if baiduyun_dir:
                sync_to_baiduyun(baiduyun_dir, destination_dir, f"{sub_folder}.tar.gz")


def recover(destination_dir, source_dir, file_prefix):
    decompress(destination_dir, source_dir, file_prefix)
