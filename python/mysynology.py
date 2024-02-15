import sys
import configparser
from job import backup_job, recovery_job, initialize


def load_config():
    config = configparser.ConfigParser()
    config.read("mysynology.config")

    if "Job" not in config:
        print("Configuration file not found or invalid.")
        sys.exit(-1)

    return config["Job"]


def run(config):
    log_folder = config.get("log_folder")
    destination = config.get("destination")
    source = config.get("source")
    baiduyun = config.get("baiduyun")
    file_prefix = config.get("file_prefix")

    initialize()
    mode = config.get("mode")

    if mode == 0:
        backup_job(log_folder, destination, source, baiduyun)
    elif mode == 1:
        recovery_job(log_folder, destination, source, file_prefix)
    else:
        print("Unknown mode. Please check the configuration file.")
        sys.exit(-1)


def start():
    config = load_config()
    run(config)


if __name__ == "__main__":
    start()