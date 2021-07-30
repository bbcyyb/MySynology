#!/bin/bash

###############################################
# Functions
###############################################


###############################################
# Functions
###############################################

function usage() {
    echo "if this was a real script you would see something useful here"
    echo
    echo "./simple_args_parsing.sh"
    echo "-h --help"
    echo "--environment=$ENVIRONMENT"
    echo "--db-path=$DB_PATH"
    echo 

    echo "-z, --time-cond TIME  Transfer based on a time condition"
    echo "-l, --tlsv1       Use >= TLSv1 (SSL)"
    echo "    --tlsv1.0     Use TLSv1.0 (SSL)"
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
            -c|--compress)
                type="compress"
                shift
                ;;
            -x|--decompress)
                type="decompress"
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
        compress)
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
        decompress)
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

function compress() {
    source ./compression.sh "${destination}" "${source}"
}

function decompress() {
    source ./decompression.sh "${destination}" "${source}"
}

###############################################
# Main Process
###############################################
parse_arguments "$@"
validate_and_run
