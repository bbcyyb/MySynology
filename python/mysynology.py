import sys
import configparser
from job import backup, recover, initialize


def load_config(key):
    config = configparser.ConfigParser()
    config.read("mysynology.config")
    return config[key]


def run(config):
    log_folder = config.get("log_folder")
    destination = config.get("packing_path")
    source = config.get("source_path")
    baiduyun = config.get("baiduyun_sync_path")
    file_prefix = config.get("file_prefix")

    initialize(log_folder)
    mode = config.get("mode")

    if mode == "0":
        backup(destination, source, baiduyun)
    elif mode == "1":
        recover(destination, source, file_prefix)
    else:
        print("Unknown mode. Please check the configuration file.")
        sys.exit(-1)


def start():
    config = load_config("job")
    run(config)


if __name__ == "__main__":
    start()