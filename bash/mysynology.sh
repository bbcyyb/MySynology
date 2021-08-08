# !/bin/bash

. ./jobs.sh

###############################################
# Functions
###############################################

function usage() {
    echo
}

function parse_arguments() {
    POSITIONAL=()

    if [[ $# -eq 0 ]]; then
        echo "You must specify one of the '--backup' or '--recovery' options "
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
                kind="backup"
                shift
                ;;
            -r|--recovery)
                kind="recovery"
                shift
                ;;
            -l|--log_folder)
                log_folder="$2"
                shift
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
            --file_prefix)
                file_prefix="$2"
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
    echo "It's type ${kind}"
    if [[ -z ${kind} ]]; then
        echo "unknown kind, exit -1"
        exit -1
    fi

    job_initialize ${log_folder}

    case ${kind} in
        backup)
            job_backup ${destination} ${source} 
            ;;
        recovery)
            job_recover ${destination} ${source} ${file_prefix}
            ;;
        *)
            echo "unidentified kind."
    esac

    if [[ $? -ne 0 ]]; then
        echo "exit -1"
        exit -1
    fi
}

function start() {
    parse_arguments "$@"
    validate_and_run
}


start "$@"