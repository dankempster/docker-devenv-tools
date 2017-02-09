#!/usr/bin/env bash

alpine=""
entryPoint=""
wantedVersion="latest"
volumeVersion="_7"

volumeComposer="composer${volumeVersion}"
volumeComposerCache="composer${volumeVersion}_cache"

#set -x

display_help () {
#    set +x

    echo "Developer Environment Tools"
    echo ""
    echo "USAGE: ddet CMD"
    echo ""
    echo "Possible commands"
    echo "    init : Initiates the environment. Creating Docker volumes and networks"
    echo ""

    return 0
}

init () {
    docker-compose -f ddet/docker-compose.yml up -d

    return 0
}

adminer () {
    docker-compose -f ddet/docker-compose.adminer.yml up -d
}

while :
do
    case "$1" in
        adminer)
            adminer
            exit 0
        ;;
        all)
            adminer
            exit 0
        ;;
        init)
            init
            exit 0
        ;;
        -c | --cmd)
            entryPoint=$2
            shift 2;
        ;;
        -h | --help)
            display_help
            # no shifting needed here, we're done.
            exit 0
        ;;
        -n | --no-alpine)
            alpine=""
            shift 1
        ;;
        -v | --verbose)
            #  It's better to assign a string, than a number like "verbose=1"
            #  because if you're debugging the script with "bash -x" code like this:
            #
            #    if [ "$verbose" ] ...
            #
            #  You will see:
            #
            #    if [ "verbose" ] ...
            #
              #  Instead of cryptic
            #
            #    if [ "1" ] ...
            #
            verbose="verbose"
            shift
        ;;
        --) # End of all options
            shift
            break;
        ;;
         -*)
            echo "Error: Unknown option: $1" >&2
            display_help
            exit 1
        ;;
        *)  # No more options
            display_help
            exit 1
        ;;
    esac
done

