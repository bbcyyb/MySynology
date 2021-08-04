# !/bin/bash

. ./jobs.sh

###############################################
# Variables 
###############################################



###############################################
# Functions
###############################################

function usage() {
    echo
}

function backup() {
    destination=$1
    source=$2
    job_backup ${destination} ${source} 
}

function recover() {
    job_recover
}

function parse_arguments() {
    POSITIONAL=()

    if [[ $# -eq 0 ]]; then
        echo "You must specify one of the '--compress' or '--decompress' options "
        echo "Try 'run --help or run -h' for more information."
        exit 0
    fi

    while [[ $# -gt 0 ]]; do
        key="$1"

        case ${key} in
            -h|--help)
                usage
                exit 0
                ;;
            -b|--backup)
                type="backup"
                shift
                ;;
            -x|--decompress)
                type="recovery"
                shift
                ;;
            -d|--destination)
                destination="$2"
                shift
                shift
                ;;
            -s|--source)
                source="$2"
                shift
                shift
                ;;
            *)
                POSITIONAL+=("$1")
                shift
        esac
    done

    set -- "${POSITIONAL[@]}"
    if [[ $# -gt 0 ]]; then
        echo "Includes unknown arguments: $*"
    fi
}

function validate_and_run() {
    if [[ -z ${type} ]]; then
        echo "invalid type, exit -1"
        exit -1
    fi

    case ${type} in
        backup)
            if [[ -z ${destination} ]]; then
                echo "--destination is missing, exit -1"
                exit -1
            fi

            if [[ -z ${source} ]]; then
                echo "--source is missing, exit -1"
                exit -1
            fi

            compress
            ;;
        recovery)
            if [[ -z ${destination} ]]; then
                echo "--destination is missing, exit -1"
                exit -1
            fi

            if [[ -z ${source} ]]; then
                echo "--source is missing, exit -1"
                exit -1
            fi

            decompress
            ;;
        *)
            echo "type is missing, exit -1"
    esac
}