import datetime
import os
import subprocess

global_log_file = None
# Don't change this password anytime
global_password = "fK2!aN1#aC4!aC2)hL1^"


def initialize_logfile(log_folder):
    if not os.path.isdir(log_folder):
        os.makedirs(log_folder)

    currentdate = datetime.datetime.now().strftime("%m_%d_%Y")
    global global_log_file
    global_log_file = f"{log_folder}/{currentdate}.log"


def log(message):
    timestamp = datetime.datetime.now().strftime("%H:%M:%S")

    if global_log_file:
        with open(global_log_file, "a") as file:
            file.write(f"[{timestamp}] => {message}\n")


def compress(destination_dir, source_dir):
    package_name = os.path.basename(source_dir.rstrip('/'))
    parent_source_dir = os.path.dirname(source_dir)
    try:
        tar_process = subprocess.run(
            ["tar", "-zcPf", "-", "-C", parent_source_dir, package_name],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
            text=True
        )
        openssl_process = subprocess.run(
            ["openssl", "des3", "-salt", "-k", global_password],
            input=tar_process.stdout,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
            text=True
        )
        split_process = subprocess.run(
            [
                "split",
                "-b", "1000m",
                "-d", "-a", "1",
                "-", f"{destination_dir}/{package_name}.tar.gz."
            ],
            input=openssl_process.stdout,
            stderr=subprocess.PIPE,
            check=True,
            text=True
        )
        return 0
    except subprocess.CalledProcessError as e:
        print(e)
        return 1


def decompress(destination_dir, source_dir, file_prefix):
    try:
        cat_process = subprocess.run(
            ["cat", f"{source_dir}/{file_prefix}.*"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
            text=True
        )
        openssl_process = subprocess.run(
            ["openssl", "des3", "-d", "-k", global_password, "-salt"],
            input=cat_process.stdout,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
            text=True
        )
        tar_process = subprocess.run(
            ["tar", "-zxf", "-", "-C", destination_dir],
            input=openssl_process.stdout,
            stderr=subprocess.PIPE,
            check=True,
            text=True
        )
        return 0
    except subprocess.CalledProcessError as e:
        print(e)
        return 1


def sync_to_baiduyun(destination_dir, source_dir, file_prefix):
    try:
        need_copy = -1
        if not file_prefix:
            return 1

        for filtered_file in os.listdir(source_dir):
            if filtered_file.startswith(file_prefix):
                filtered_name = os.path.basename(filtered_file)
                source_file_size = os.path.getsize(os.path.join(source_dir, filtered_file))
                destination_file = os.path.join(destination_dir, filtered_name)
                if not os.path.isfile(destination_file) or os.path.getsize(destination_file) != source_file_size:
                    need_copy = 0
                    break

        if need_copy == 0:
            log("sync data")
            # delete existed files from dest
            for dest_file in os.listdir(destination_dir):
                if dest_file.startswith(file_prefix):
                    os.remove(os.path.join(destination_dir, dest_file))
            # move file to dest folder
            for src_file in os.listdir(source_dir):
                if src_file.startswith(file_prefix):
                    os.rename(os.path.join(source_dir, src_file), os.path.join(destination_dir, src_file))
        else:
            log("keep data")
            for src_file in os.listdir(source_dir):
                if src_file.startswith(file_prefix):
                    os.remove(os.path.join(source_dir, src_file))

        return 0
    except Exception as e:
        print(e)
        return 1
