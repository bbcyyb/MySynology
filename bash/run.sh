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

    case ${kind} in
        backup)
            if [[ -z ${destination} ]]; then
                echo "--destination is missing, exit -1"
                exit -1
            fi

            if [[ -z ${source} ]]; then
                echo "--source is missing, exit -1"
                exit -1
            fi

            job_backup ${destination} ${source} 
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

            if [[ -z ${file_prefix} ]]; then
                echo "--file prefix is missing, exit -1"
                exit -1
            fi

            job_recover ${destination} ${source} ${file_prefix}
            ;;
        *)
            echo "type is missing, exit -1"
    esac
}

function start() {
    parse_arguments "$@"
    validate_and_run
}


# start "$@"

function test() {

    list=()

    path=/home/yuk4/work/sourcecode/github/bbcyyb/MySynology/test/b_side/temp

    for sub in `ls ${path}`
    do
        list=("${list[@]}" "${sub%.*}")
    done

    for l in ${list[@]}
    do
        for ll in `ls "$path/$l"*`
        do
            echo $ll
        done
    done
}

test
